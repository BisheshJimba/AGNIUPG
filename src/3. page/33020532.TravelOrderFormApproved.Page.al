page 33020532 "Travel Order Form (Approved)"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020425;
    SourceTableView = SORTING(Travel Order No., Traveler's ID)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes),
                            Approved II=CONST(Yes),
                            Invalid=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Travel Order No."; "Travel Order No.")
                {
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field("Traveler's ID"; "Traveler's ID")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                }
                field("Approved By"; "Approved By")
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
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //MESSAGE('Approve');
                    TravelOrderForm.RESET;
                    TravelOrderForm.SETRANGE("Travel Order No.", "Travel Order No.");
                    IF TravelOrderForm.FINDFIRST THEN
                        REPORT.RUNMODAL(33020505, TRUE, FALSE, TravelOrderForm);
                end;
            }
            action("Invalid Document")
            {
                Caption = 'Invalid Document';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TravelOrderForm.InvalidOrder("Travel Order No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        HRPermission.GET(USERID);
        IF HRPermission."Travel Order Post" = FALSE THEN
            ERROR('You Do Not Have Permission To View the Posted Travel Form!');
    end;

    var
        HRPermission: Record "33020304";
        TravelOrderForm: Record "33020425";
}

