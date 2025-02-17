page 33020448 "Posted Intern Lists"
{
    CardPageID = "Intern Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33020402;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("College/ Institution Name"; "College/ Institution Name")
                {
                }
                field(Education; Education)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Direct Supervisor"; "Direct Supervisor")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Complete Date"; "Complete Date")
                {
                }
                field("Duration (Months)"; "Duration (Months)")
                {
                }
                field(Attendance; Attendance)
                {
                }
                field(IDate; IDate)
                {
                }
                field(Report; Report)
                {
                }
                field("Experience Letter"; "Experience Letter")
                {
                }
                field(Company; Company)
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
        area(reporting)
        {
            action("<Action1000000019>")
            {
                Caption = 'Print-Experience Letter';
                Image = Print;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report 33020344;

                trigger OnAction()
                begin
                    /*InternRec1.RESET;
                    InternRec1.SETRANGE("Entry No.","Entry No.");
                    IF InternRec1.FINDFIRST THEN
                      //report.runmodal(33020343,true,false,InternRec1);   */

                    //CurrPage.SETSELECTIONFILTER(InternRec1);

                end;
            }
        }
    }

    var
        InternRec1: Record "33020402";
}

