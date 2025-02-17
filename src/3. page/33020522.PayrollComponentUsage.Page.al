page 33020522 "Payroll Component Usage"
{
    PageType = List;
    SourceTable = Table33020504;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Column Name"; "Column Name")
                {
                }
                field("Payroll Component Code"; "Payroll Component Code")
                {
                }
                field("Payroll Component Description"; "Payroll Component Description")
                {
                }
                field("Payroll Type"; "Payroll Type")
                {
                }
                field("Payroll Subtype"; "Payroll Subtype")
                {
                }
                field(Fixed; Fixed)
                {
                }
                field(Formula; Formula)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Applicable Month"; "Applicable Month")
                {
                }
                field("Applicable from"; "Applicable from")
                {
                }
                field("Applicable to"; "Applicable to")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000013>")
            {
                Caption = 'Insert Group';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    InsertGroup;
                end;
            }
        }
    }
}

