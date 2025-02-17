page 33020545 "Allotment Deallotment History"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020331;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field(Link; Link)
                {
                }
                field(Type; Type)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Current Locatoin of Vehicle"; "Current Locatoin of Vehicle")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Run Allotment Deallotment")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UserSetup: Record "91";
                    RunErr: Label 'You do not have permission to run vehicle allotment process. Please contact your system administrator.';
                begin
                    UserSetup.GET(USERID);
                    IF UserSetup."Can Run Veh. Allotment" THEN
                        VehAllotmentMgt.RUN
                    ELSE
                        ERROR(RunErr);
                end;
            }
            action("Confirmed Details")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020549;
            }
            action("Update Vehicle Order Detail")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RunErr: Label 'You do not have permission to run vehicle allotment process. Please contact your system administrator.';
                begin
                    UserSetup.GET(USERID);
                    IF UserSetup."Can Run Veh. Allotment" THEN
                        //VehAllotmentMgt.RUN
                        REPORT.RUN(33020050)
                    ELSE
                        ERROR(RunErr);
                end;
            }
        }
    }

    var
        VehAllotmentMgt: Codeunit "50009";
        UserSetup: Record "91";
}

