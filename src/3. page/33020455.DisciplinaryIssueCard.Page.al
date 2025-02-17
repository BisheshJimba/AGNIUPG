page 33020455 "Disciplinary Issue Card"
{
    PageType = Card;
    SourceTable = Table33020405;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Discipline No."; "Discipline No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                    Editable = false;
                }
                field(Designation; Designation)
                {
                    Editable = false;
                }
                field(Grade; Grade)
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field(Branch; Branch)
                {
                    Editable = false;
                }
                field("Issue Reported Date (BS)"; "Issue Reported Date (BS)")
                {

                    trigger OnValidate()
                    begin
                        "Eng-NepRec".RESET;
                        "Eng-NepRec".SETRANGE("Nepali Date", "Issue Reported Date (BS)");
                        IF "Eng-NepRec".FINDFIRST THEN BEGIN
                            "Issue Reported Date (AD)" := "Eng-NepRec"."English Date";
                            "Fiscal Year" := "Eng-NepRec"."Fiscal Year";
                        END;
                    end;
                }
                field("Issue Reported Date (AD)"; "Issue Reported Date (AD)")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Issue; Issue)
                {
                }
                field(Status; Status)
                {
                }
                field("Spastikaran Date(BS)"; "Spastikaran Date(BS)")
                {

                    trigger OnValidate()
                    begin
                        "Eng-NepRec".RESET;
                        "Eng-NepRec".SETRANGE("Nepali Date", "Spastikaran Date(BS)");
                        IF "Eng-NepRec".FINDFIRST THEN BEGIN
                            "Spastikaran Date (AD)" := "Eng-NepRec"."English Date";
                        END;
                    end;
                }
                field("Spastikaran Date (AD)"; "Spastikaran Date (AD)")
                {
                }
                field("Spastikaran Received Date(BS)"; "Spastikaran Received Date(BS)")
                {

                    trigger OnValidate()
                    begin
                        "Eng-NepRec".RESET;
                        "Eng-NepRec".SETRANGE("Nepali Date", "Spastikaran Received Date(BS)");
                        IF "Eng-NepRec".FINDFIRST THEN BEGIN
                            "Spastikaran Received Date (AD)" := "Eng-NepRec"."English Date";
                        END;
                    end;
                }
                field("Spastikaran Received Date (AD)"; "Spastikaran Received Date (AD)")
                {
                }
                field("Spastikaran Jawaf Date(BS)"; "Spastikaran Jawaf Date(BS)")
                {

                    trigger OnValidate()
                    begin
                        "Eng-NepRec".RESET;
                        "Eng-NepRec".SETRANGE("Nepali Date", "Spastikaran Jawaf Date(BS)");
                        IF "Eng-NepRec".FINDFIRST THEN BEGIN
                            "Spastikaran Jawaf Date(AD)" := "Eng-NepRec"."English Date";
                        END;
                    end;
                }
                field("Spastikaran Jawaf Date(AD)"; "Spastikaran Jawaf Date(AD)")
                {
                }
                field("Spastikaran Jawaf Received(BS)"; "Spastikaran Jawaf Received(BS)")
                {

                    trigger OnValidate()
                    begin
                        "Eng-NepRec".RESET;
                        "Eng-NepRec".SETRANGE("Nepali Date", "Spastikaran Jawaf Received(BS)");
                        IF "Eng-NepRec".FINDFIRST THEN BEGIN
                            "Spastikaran Jawaf Received(AD)" := "Eng-NepRec"."English Date";
                        END;
                    end;
                }
                field(Action; Action)
                {
                }
                field("Action Date"; "Action Date")
                {
                }
                field("Action WEF"; "Action WEF")
                {
                }
                field(Remarks; Remarks)
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
            action("<Action1000000022>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DispRec.SETRANGE(DispRec."Discipline No.", "Discipline No.");
                    IF DispRec.FINDFIRST THEN BEGIN
                        IF DispRec.Posted = FALSE THEN BEGIN
                            DispRec.Posted := TRUE;
                            DispRec."Posted Date" := TODAY;
                            DispRec."Posted By" := USERID;
                            DispRec.MODIFY;
                            MESSAGE(text0001);
                        END ELSE BEGIN
                            MESSAGE(text0002);
                        END;
                    END;
                end;
            }
        }
    }

    var
        DispRec: Record "33020405";
        text0001: Label 'Record Inserted Successfully!';
        text0002: Label 'Record Updated Successfully!!';
        "Eng-NepRec": Record "33020302";
}

