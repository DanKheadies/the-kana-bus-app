import { onCall } from "firebase-functions/v2/https";
import { handleHelpMessage } from "./funcs/helpMessage";

/**
 * Contact Message
 *
 * Send an "email" to Firebase document.
 * TODO: incorporate a true email service or send as a push notification topic.
 */
export const helpMessage = onCall(async (data) => handleHelpMessage(data));
