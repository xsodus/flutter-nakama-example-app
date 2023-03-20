// The complete set of opcodes used for communication between clients and server.
enum OpCode {
  // New game round starting.
  START = 1,
  // Update to the state of an ongoing round.
  UPDATE = 2,
  // A game round has just completed.
  DONE = 3,
  // A move the player wishes to make and sends to the server.
  MOVE = 4,
  // Move was rejected.
  REJECTED = 5,
}
