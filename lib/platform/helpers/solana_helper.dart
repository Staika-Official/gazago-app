
import 'package:solana/solana.dart';
import 'package:solana/dto.dart';

Message getSolTransferMessage(Ed25519HDPublicKey fundingAccount, Ed25519HDPublicKey recipientAccount, int amount, int priorityFee) {
  final instruction = SystemInstruction.transfer(
    fundingAccount: fundingAccount,
    recipientAccount: recipientAccount,
    lamports: amount,
  );
  // return Message.only(instruction);
  return Message(
    instructions: [
      instruction,
      ComputeBudgetInstruction.setComputeUnitLimit(
        units: 100000,
      ),
      ComputeBudgetInstruction.setComputeUnitPrice(
        microLamports: priorityFee,
      ),

      /*,
        if (memo != null && memo.isNotEmpty)
          MemoInstruction(signers: [owner.publicKey], memo: memo),*/
    ],
  );
}

Future<Message> getSplTransferMessage(SolanaClient solanaClient, Ed25519HDKeyPair sender, Ed25519HDPublicKey destination, Ed25519HDPublicKey mint, int amount, int priorityFee) async {
  final commitment = Commitment.confirmed;
  print('priorityFee : $priorityFee');
  ProgramAccount? associatedRecipientAccount = await solanaClient.getAssociatedTokenAccount(
    owner: destination,
    mint: mint,
    commitment: commitment,
  );
  ProgramAccount? associatedSenderAccount = await solanaClient.getAssociatedTokenAccount(
    owner: sender.publicKey,
    mint: mint,
    commitment: commitment,
  );

  // Throw an appropriate exception if the sender has no associated
  associatedSenderAccount ??= await solanaClient.createAssociatedTokenAccount(
    mint: mint,
    funder: sender,
    owner: sender.publicKey,
    commitment: commitment,
  );

  // Also throw an adequate exception if the recipient has no associated
  associatedRecipientAccount ??= await solanaClient.createAssociatedTokenAccount(
      mint: mint,
      funder: sender,
      owner: destination,
      commitment: commitment,
    );

  print('associatedSenderAccount: ${associatedSenderAccount.pubkey}');
  print('associatedRecipientAccount: ${associatedRecipientAccount.pubkey}');

  final instruction = TokenInstruction.transfer(
    source: Ed25519HDPublicKey.fromBase58(associatedSenderAccount.pubkey),
    destination:
    Ed25519HDPublicKey.fromBase58(associatedRecipientAccount.pubkey),
    owner: sender.publicKey,
    amount: amount,
  );

  return Message(
    instructions: [
      instruction,
      ComputeBudgetInstruction.setComputeUnitLimit(
        units: 100000,
      ),
      ComputeBudgetInstruction.setComputeUnitPrice(
        microLamports: priorityFee,
      ),
      /*,
        if (memo != null && memo.isNotEmpty)
          MemoInstruction(signers: [owner.publicKey], memo: memo),*/
    ],
  );
}

