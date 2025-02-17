page 33020388 "Posted Half Appraisal List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020361;
    SourceTableView = WHERE(Appraisal Type=CONST(Half-Annual));

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
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Appraisal.RESET;
                    Appraisal.SETRANGE(Appraisal."Employee Code", "Employee Code");
                    Appraisal.SETRANGE(Appraisal."Entry No.", "Entry No.");
                    IF Appraisal.FINDFIRST THEN BEGIN
                        Appraisal.SETRANGE(Appraisal.Category, 'CAT-1');
                        IF Appraisal.FINDFIRST THEN
                            REPORT.RUNMODAL(33020330, TRUE, FALSE, Appraisal);
                        Appraisal.SETRANGE(Appraisal.Category, 'CAT-2');
                        IF Appraisal.FINDFIRST THEN
                            REPORT.RUNMODAL(33020331, TRUE, FALSE, Appraisal);

                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        HRPer: Record "33020304";
    begin
        /*HRPer.GET(USERID);
        IF NOT HRPer."HR Admin" THEN
          ERROR('Only HR is permitted.');*/
        FILTERGROUP(2);
        HRPermission.GET(USERID);
        IF NOT HRPermission."HR Master" THEN
            SETFILTER("Appraisal 2 UserID", USERID);
        FILTERGROUP(0);

    end;

    var
        Appraisal: Record "33020361";
        HRPermission: Record "33020304";
}

