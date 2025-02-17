codeunit 33019888 "Print Gate Pass"
{
    SingleInstance = false;
    TableNo = 33019894;

    trigger OnRun()
    var
        BattService: Record "33019884";
    begin
        // message('%1',GblJobCard."Job Card No.");

        JobHeader.COPY(Rec);

        JobLines.SETRANGE(JobLines."Job Card No.", JobHeader."Job Card No.");
        IF JobLines.FINDFIRST THEN BEGIN
            PrintJobCard(JobHeader, JobLines);
            COMMIT;
        END;
    end;

    var
        GblJobCard: Record "33019884";
        GblJobCardLines: Record "33019885";
        JobHeader: Record "33019894";
        JobLines: Record "33019895";

    [Scope('Internal')]
    procedure PrintJobCard(PrmJobCard: Record "33019894"; PrmJobCardLine: Record "33019895")
    var
        JobCardHeader: Record "33019894";
        JobCardLine: Record "33019895";
        ReportSelection: Record "77";
    begin
        JobCardHeader.RESET;
        JobCardLine.RESET;
        JobCardHeader.COPY(JobHeader);
        JobCardLine.COPY(JobLines);
        JobCardHeader.SETRANGE("Job Card No.", PrmJobCard."Job Card No.");
        IF JobCardHeader.FINDFIRST THEN BEGIN
            JobCardLine.SETRANGE("Job Card No.", PrmJobCardLine."Job Card No.");
            IF JobCardLine.FINDFIRST THEN BEGIN
                REPORT.RUNMODAL(33019892, TRUE, FALSE, JobCardHeader);
            END;
        END;
    end;
}

