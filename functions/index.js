// Dependencies
const uuid4 = require("uuid4");

// The Cloud Functions for Firebase SDK to create Cloud Functions
// and setup triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

const database = admin.database();

exports.matchMaker = functions.database.ref("wait_queue/{playerId}")
    .onCreate((snapshot, context) => {
      const matchId = uuid4();
      let player1Name = snapshot.val().name;
      let player1Match = snapshot.val().match;
      let player2 = null;

      console.log(matchId);
      console.log(player1Name);
      console.log(player1Match);

      database.ref("wait_queue").once("value").then((playerInfoList) => {
        playerInfoList.forEach((playerInfo) => {
          if (playerInfo.val().match === "" &&
              playerInfo.key !== context.params.playerId) {
            player2 = playerInfo;
            console.log(player2);
            break;
          }
        });

        if (player2 == null) return null;

        database.ref("wait_queue").transaction(function(waitQueue) {
          // If any of the players gets into another game
          // during the transaction, abort the operation
          if (waitQueue === null ||
              waitQueue[context.params.playerId].match !== "" ||
              waitQueue[player2.key].match !== "") {
            return waitQueue;
          }

          waitQueue[context.params.playerId].match = matchId;
          waitQueue[player2.key].match = matchId;
          return waitQueue;
        }).then((result) => {
          const player1Id = context.params.playerId;
          if (result.snapshot.child(player1Id).val().match !== matchId) {
            return;
          }

          const match = {
            info: {
              match_id: matchId,
              player_ids: [player1Id, player2.key],
              player_names: [player1Name, player2.val().name]
            },
            player_turn: 1,
            latest_move: -1,
            ready: 0,
            done: 0,
          };

          database.ref("matches/" + matchId).set(match).then((snapshot) => {
            console.log("Create game successfully");
            return null;
          }).catch((error) => {
            console.log(error);
          });

          return null;
        }).catch((error) => {
          console.log(error);
        });
      });
    });
