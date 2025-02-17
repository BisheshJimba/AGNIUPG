codeunit 25006012 "Datetime Mgt."
{
    // 15.07.2008. EDMS P2
    //   * Move from Microsoft Dynamics 4.0


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure Datetime(Date: Date; Time: Time): Decimal
    begin
        IF Date = 0D THEN
            Date := 01010000D;

        IF Time = 0T THEN
            EXIT((Date - 01010000D) * 86.4)
        ELSE
            EXIT(((Date - 01010000D) * 86.4) + (Time - 000000T) / 1000000);
    end;

    [Scope('Internal')]
    procedure Datetime2Time(Datetime: Decimal): Time
    begin
        IF Datetime = 0 THEN
            EXIT(0T);
        EXIT(000000T + (Datetime MOD 86.4) * 1000000);
    end;

    [Scope('Internal')]
    procedure Datetime2Date(Datetime: Decimal): Date
    begin
        IF Datetime = 0 THEN
            EXIT(0D);
        EXIT(01010000D + ROUND(Datetime / 86.4, 1, '<'));
    end;

    [Scope('Internal')]
    procedure Datetime2Text(Datetime: Decimal): Text[260]
    begin
        IF Datetime = 0 THEN
            EXIT('')
        ELSE
            EXIT(STRSUBSTNO('%1 %2', Datetime2Date(Datetime), Datetime2Time(Datetime)));
    end;

    [Scope('Internal')]
    procedure Text2Datetime(Text: Text[260]): Decimal
    var
        Pos: Integer;
        Date: Date;
        Time: Time;
    begin
        Text := DELCHR(Text, '<>', ' ');
        IF STRLEN(Text) = 0 THEN
            EXIT(0);

        Pos := STRPOS(Text, ' ');
        IF Pos = 0 THEN
            Pos := STRPOS(Text, '+');
        IF Pos > 0 THEN BEGIN
            EVALUATE(Date, COPYSTR(Text, 1, Pos - 1));
            EVALUATE(Time, COPYSTR(Text, Pos + 1));
        END ELSE BEGIN
            EVALUATE(Date, Text);
            Time := 000000T;
        END;

        EXIT(Datetime(Date, Time));
    end;
}

