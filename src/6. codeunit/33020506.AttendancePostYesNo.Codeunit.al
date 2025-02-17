codeunit 33020506 "Attendance-Post (Yes/No)"
{
    TableNo = 33020555;

    trigger OnRun()
    begin
        AttJnlLine.COPY(Rec);
        Code;
        Rec := AttJnlLine;
    end;

    var
        AttJnlLine: Record "33020555";
        AttPost: Codeunit "33020505";

    [Scope('Internal')]
    procedure "Code"()
    var
        Text001: Label 'Do you want to post the Journal?';
    begin
        IF NOT CONFIRM(Text001, TRUE) THEN
            EXIT;
        AttPost.RUN(AttJnlLine);
        COMMIT;
    end;
}

