page 33020451 "Posted Trainee Lists"
{
    CardPageID = "Trainee Card";
    Editable = true;
    PageType = List;
    SourceTable = Table33020403;
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
                field("Ward No."; "Ward No.")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Education; Education)
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Complete Date"; "Complete Date")
                {
                }
                field(Durations; Durations)
                {
                }
                field(Designation; Designation)
                {
                }
                field("Direct Supervisor"; "Direct Supervisor")
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field(Remarks; Remarks)
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
        area(processing)
        {
            action("<Action1000000017>")
            {
                Caption = 'Print-Experience Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TraineeRec.RESET;
                    TraineeRec.SETRANGE("Entry No.", "Entry No.");
                    IF TraineeRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020344, TRUE, FALSE, TraineeRec);
                    END;
                end;
            }
        }
    }

    var
        TraineeRec: Record "33020403";
}

