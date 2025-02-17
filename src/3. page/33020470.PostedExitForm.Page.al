page 33020470 "Posted Exit Form"
{
    CardPageID = "Employee Exit Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020410;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Exit No."; "Exit No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field(Desgination; Desgination)
                {
                }
                field("Joining Date"; "Joining Date")
                {
                }
                field(Department; Department)
                {
                }
                field("Date of Leaving"; "Date of Leaving")
                {
                }
                field(Company; Company)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
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
                    ExitRec.RESET;
                    ExitRec.SETRANGE("Exit No.", "Exit No.");
                    ExitRec.SETRANGE("Employee Code", "Employee Code");
                    IF ExitRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020341, TRUE, FALSE, ExitRec);
                    END;
                end;
            }
        }
    }

    var
        ExitRec: Record "33020410";
}

