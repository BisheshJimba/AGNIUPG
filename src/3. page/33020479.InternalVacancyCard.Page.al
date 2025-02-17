page 33020479 "Internal Vacancy Card"
{
    PageType = Card;
    SourceTable = Table33020415;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vacancy Code"; "Vacancy Code")
                {

                    trigger OnValidate()
                    begin
                        "Posted By" := USERID;
                    end;
                }
                field("For Job Title Code"; "For Job Title Code")
                {

                    trigger OnValidate()
                    begin
                        JobTitleRec.RESET;
                        JobTitleRec.SETRANGE(Code, "For Job Title Code");
                        IF JobTitleRec.FINDFIRST THEN
                            "For Job Title" := JobTitleRec.Description;
                        IF JobTitleRec.COUNT = 0 THEN
                            "For Job Title" := '';
                    end;
                }
                field("For Job Title"; "For Job Title")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Closed)
            {
                Caption = 'Closed';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF ("Closed Date" - TODAY) > 0 THEN
                        ERROR('You have not reach the close date');
                    IF ("Closed Date" - TODAY) = 0 THEN
                        ERROR('You have not reach the close date');

                    ConfirmPost := DIALOG.CONFIRM(text001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        Closed := TRUE;
                        "Closed By" := USERID;
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text001: Label 'Do you want to Close this Vacancy?';
        JobTitleRec: Record "33020325";
}

