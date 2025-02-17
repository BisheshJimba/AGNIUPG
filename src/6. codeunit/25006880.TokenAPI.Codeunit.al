codeunit 25006880 "Token API"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure TopUpTokens(Amount: Decimal; DocumentNo: Code[20]) Balance: Decimal
    var
        CommunicationTokenLedger: Record "25006881";
        n: Integer;
    begin
        CommunicationTokenLedger.RESET;

        n := 1;
        IF CommunicationTokenLedger.FINDLAST THEN
            n := CommunicationTokenLedger."Entry No." + 1;

        CommunicationTokenLedger.INIT;
        CommunicationTokenLedger."Entry No." := n;
        CommunicationTokenLedger."Token Qty." := Amount;
        CommunicationTokenLedger.Description := 'Top-up';
        CommunicationTokenLedger.Date := TODAY;
        CommunicationTokenLedger.Time := TIME;
        CommunicationTokenLedger."Operation Count" := 1;
        CommunicationTokenLedger."Service Code" := 'TOP-UP';
        CommunicationTokenLedger."Operation No." := DocumentNo;
        CommunicationTokenLedger."User ID" := USERID;
        CommunicationTokenLedger.INSERT;

        CommunicationTokenLedger.RESET;
        CommunicationTokenLedger.CALCSUMS("Token Qty.");
        Balance := CommunicationTokenLedger."Token Qty.";
    end;

    [Scope('Internal')]
    procedure GetCurrentBalance() Balance: Decimal
    var
        CommunicationTokenLedger: Record "25006881";
    begin
        CommunicationTokenLedger.RESET;
        CommunicationTokenLedger.CALCSUMS("Token Qty.");
        Balance := CommunicationTokenLedger."Token Qty.";
    end;
}

