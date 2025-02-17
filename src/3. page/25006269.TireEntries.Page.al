page 25006269 "Tire Entries"
{
    Caption = 'Tire Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table25006181;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Axle Code"; "Vehicle Axle Code")
                {
                }
                field("Tire Position Code"; "Tire Position Code")
                {
                }
                field("Tire Code"; "Tire Code")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field(Open; Open)
                {
                }
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Service Ledger Entry No."; "Service Ledger Entry No.")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page "344";
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
            action("Print List")
            {
                Caption = 'Print List';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 50000;
            }
            action(Test)
            {
                Caption = 'Test';
                Image = TestFile;
                RunObject = Report 50002;
            }
        }
    }
}

