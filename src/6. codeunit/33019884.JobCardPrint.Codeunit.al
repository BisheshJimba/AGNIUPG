codeunit 33019884 "Job Card Print"
{
    SingleInstance = false;
    TableNo = 33019884;

    trigger OnRun()
    var
        BattService: Record "33019884";
    begin
        // message('%1',GblJobCard."Job Card No.");

        GblJobCard.COPY(Rec);

        GblJobCardLines.SETRANGE(GblJobCardLines."Job Card No.", GblJobCard."Job Card No.");
        IF GblJobCardLines.FINDFIRST THEN BEGIN
            PrintJobCard(GblJobCard, GblJobCardLines);
            COMMIT;
        END;
    end;

    var
        GblJobCard: Record "33019884";
        GblJobCardLines: Record "33019885";

    [Scope('Internal')]
    procedure PrintJobCard(PrmJobCard: Record "33019884"; PrmJobCardLine: Record "33019885")
    var
        LclJobCard: Record "33019884";
        LclJobCardLine: Record "33019885";
        ReportSelection: Record "77";
    begin
        LclJobCard.RESET;
        LclJobCardLine.RESET;
        LclJobCard.COPY(GblJobCard);
        LclJobCardLine.COPY(GblJobCardLines);
        LclJobCard.SETRANGE("Job Card No.", PrmJobCard."Job Card No.");
        IF LclJobCard.FINDFIRST THEN BEGIN
            LclJobCardLine.SETRANGE(LclJobCardLine."Job Card No.", PrmJobCardLine."Job Card No.");
            IF LclJobCardLine.FINDFIRST THEN BEGIN
                REPORT.RUNMODAL(33019884, TRUE, FALSE, LclJobCard);
            END;
        END;
    end;
}

