codeunit 25006881 "Token Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Service is not available, token balance = %1;';

    [Scope('Internal')]
    procedure CheckTokens(Quantity: Integer; ServiceCode: Code[20]; var ErrorMsg: Text) ServiceAvailable: Boolean
    var
        ThirdPartiesService: Record "25006880";
        TokenLedger: Record "25006881";
    begin
        ServiceAvailable := FALSE;
        ErrorMsg := '';
        ThirdPartiesService.GET(ServiceCode);
        IF NOT ThirdPartiesService."Tokens Enabled" THEN BEGIN
            ServiceAvailable := TRUE;
            EXIT;
        END;
        TokenLedger.RESET;
        TokenLedger.CALCSUMS("Token Qty.");
        IF (TokenLedger."Token Qty." - ThirdPartiesService.Price * Quantity) < 0 THEN BEGIN
            ServiceAvailable := FALSE;
            ErrorMsg := STRSUBSTNO(Text001, FORMAT(TokenLedger."Token Qty."));
        END ELSE
            ServiceAvailable := TRUE;
    end;

    [Scope('Internal')]
    procedure RegisterSpentTokens(OperationCount: Integer; ServiceCode: Code[20]; OperationNo: Code[20])
    var
        n: Integer;
        ThirdPartiesService: Record "25006880";
        TokenLedger: Record "25006881";
    begin
        ThirdPartiesService.GET(ServiceCode);
        IF NOT ThirdPartiesService."Tokens Enabled" THEN
            EXIT;

        TokenLedger.RESET;
        n := 1;
        IF TokenLedger.FINDLAST THEN
            n := TokenLedger."Entry No." + 1;
        TokenLedger.INIT;
        TokenLedger."Entry No." := n;
        TokenLedger."Service Code" := ServiceCode;
        TokenLedger."Operation No." := OperationNo;
        TokenLedger.Description := ThirdPartiesService.Description;
        TokenLedger."Operation Count" := -OperationCount;
        TokenLedger."Token Qty." := -OperationCount * ThirdPartiesService.Price;
        TokenLedger.Date := TODAY;
        TokenLedger.Time := TIME;
        TokenLedger."User ID" := USERID;
        TokenLedger.INSERT;
    end;
}

