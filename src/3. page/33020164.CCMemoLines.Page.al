page 33020164 "CC Memo Lines"
{
    PageType = ListPart;
    SourceTable = Table33020164;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Chasis No."; "Chasis No.")
                {
                }
                field("ARE1 No."; "ARE1 No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("To Branch"; "To Branch")
                {
                }
                field(Model; Model)
                {
                }
                field("Model Name"; "Model Name")
                {
                }
                field("Model Version"; "Model Version")
                {
                }
                field("Model Version Desc."; "Model Version Desc.")
                {
                }
                field("PP No."; "PP No.")
                {
                }
                field("PP Date"; "PP Date")
                {
                }
                field("Veh. Reg No."; "Veh. Reg No.")
                {
                }
                field("C & F Date"; "C & F Date")
                {
                }
                field("C & F Date (BS)"; "C & F Date (BS)")
                {
                }
                field("C & F Amount"; "C & F Amount")
                {
                }
                field("INS Memo No."; "INS Memo No.")
                {
                    Visible = false;
                }
                field("INS Memo Date"; "INS Memo Date")
                {
                    Visible = false;
                }
                field("INS Memo Date (BS)"; "INS Memo Date (BS)")
                {
                    Visible = false;
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("INS Memo No.", "INS Memo Date", "INS Memo Date (BS)");
    end;
}

