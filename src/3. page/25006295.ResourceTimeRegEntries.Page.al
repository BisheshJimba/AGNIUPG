page 25006295 "Resource Time Reg. Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = Table25006290;
    SourceTableView = WHERE(Canceled = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Allocation Entry No."; "Allocation Entry No.")
                {
                }
                field("Resource No."; "Resource No.")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field("Time Spent"; "Time Spent")
                {
                }
                field(Travel; Travel)
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source Subtype"; "Source Subtype")
                {
                }
                field("Source ID"; "Source ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action(ModifyResourceTimeRegEntry)
                {
                    Caption = 'Modify Last Entry Time';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.ModifyLastTimeRegEntry(Rec);
                    end;
                }
            }
        }
    }

    var
        ResourceTimeRegMgt: Codeunit "25006290";
}

