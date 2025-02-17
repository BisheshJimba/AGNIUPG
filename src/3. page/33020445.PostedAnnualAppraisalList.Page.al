page 33020445 "Posted Annual Appraisal List"
{
    PageType = List;
    SourceTable = Table33020361;
    SourceTableView = WHERE(Appraisal Type=CONST(Annual));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Appraiser 1 Name"; "Appraiser 1 Name")
                {
                }
                field("Appraiser 2 Name"; "Appraiser 2 Name")
                {
                }
                field("Recommended For Promotion"; "Recommended For Promotion")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("No. of years in Service Period"; "No. of years in Service Period")
                {
                }
                field("Remarks I"; "Remarks I")
                {
                }
                field("Level/Grade"; "Level/Grade")
                {
                }
                field("Promotion Type"; "Promotion Type")
                {
                }
                field("Total Average"; "Total Average")
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
            action(Print)
            {
                Image = print;

                trigger OnAction()
                begin
                    /*Appraisal.RESET;
                    Appraisal.SETRANGE(Appraisal."Employee Code","Employee Code");
                    Appraisal.SETRANGE(Appraisal."Entry No.","Entry No.");
                    IF Appraisal.FINDFIRST THEN BEGIN
                          REPORT.RUNMODAL(33020331,TRUE,FALSE,Appraisal);
                    
                    END;   */

                    PresentFiscal := "Fiscal Year";
                    //MESSAGE(FORMAT(PresentFiscal));
                    "ENg-Nep".RESET;
                    "ENg-Nep".SETRANGE("Fiscal Year", PresentFiscal);
                    IF "ENg-Nep".FINDFIRST THEN BEGIN
                        EngDate := "ENg-Nep"."English Date";
                    END;
                    EngDate := EngDate - 10;
                    "Eng-Nep1".RESET;
                    "Eng-Nep1".SETRANGE("English Date", EngDate);
                    IF "Eng-Nep1".FINDFIRST THEN BEGIN
                        PreviousFiscal := "Eng-Nep1"."Fiscal Year";
                    END;
                    //MESSAGE(FORMAT(PreviousFiscal));

                    Appraisal.RESET;
                    Appraisal.SETRANGE(Appraisal."Employee Code", "Employee Code");
                    Appraisal.SETRANGE(Appraisal."Entry No.", "Entry No.");
                    IF Appraisal.FINDFIRST THEN BEGIN
                        Appraisal.SETRANGE(Appraisal.Category, 'CAT-1');
                        Appraisal.SETRANGE("Fiscal Year", "Fiscal Year");
                        IF Appraisal.FINDFIRST THEN
                            REPORT.RUNMODAL(33020328, TRUE, FALSE, Appraisal);
                        // report.runmodal(33020304,true,false,appraisal);
                        Appraisal.SETRANGE(Appraisal.Category, 'CAT-2');
                        IF Appraisal.FINDFIRST THEN
                            REPORT.RUNMODAL(33020329, TRUE, FALSE, Appraisal);
                    END;
                    ObjectiveRec.RESET;
                    ObjectiveRec.SETRANGE("Employee Code", "Employee Code");
                    ObjectiveRec.SETRANGE("Fiscal Year", "Fiscal Year");
                    IF ObjectiveRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020304, TRUE, FALSE, ObjectiveRec);
                    END;

                    ObjectiveRec.RESET;
                    ObjectiveRec.SETRANGE("Employee Code", "Employee Code");
                    ObjectiveRec.SETRANGE("Fiscal Year", PreviousFiscal);
                    IF ObjectiveRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020305, TRUE, FALSE, ObjectiveRec);
                    END;

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        FILTERGROUP(2);
        HRPermission.GET(USERID);
        IF NOT HRPermission."HR Master" THEN
            SETFILTER("Appraisal 1 UserID", USERID);
        FILTERGROUP(0)
    end;

    var
        HRPermission: Record "33020304";
        Isvisible: Boolean;
        Appraisal: Record "33020361";
        PresentFiscal: Code[10];
        PreviousFiscal: Code[10];
        "ENg-Nep": Record "33020302";
        EngDate: Date;
        "Eng-Nep1": Record "33020302";
        ObjectiveRec: Record "33020424";
        ObjectiveRec1: Record "33020424";
}

