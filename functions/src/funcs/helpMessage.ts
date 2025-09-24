/* eslint-disable max-len */
import * as firebase from "../firebase/firebase";
import {Message} from "../models/message";

/**
 * Contact Message - [Callable Function]
 * This function sends a message to a firebase collection
 *
 * @param {any} data
 */
export async function handleHelpMessage(data: any) {
  const userEmail = data.data["email"];
  const userMessage = data.data["message"];
  const date = new Date();

  await firebase.firestore.runTransaction(async (transaction) => {
    const message: Message = {
      email: userEmail,
      message: userMessage,
      sent: new Date().toISOString(),
    };
    firebase.messages.createMessage(transaction, message);
    console.log(`Message created @ ${date}`);
  });
}
