page 33020174 "Ins. Memo Lines"
{
    PageType = ListPart;
    SourceTable = Table33020166;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Chasis No."; "Chasis No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("DRP No."; "DRP No.")
                {
                }
                field(Model; Model)
                {
                }
                field("Model Description"; "Model Description")
                {
                }
                field("Model Version"; "Model Version")
                {
                }
                field("Model Version Desc."; "Model Version Desc.")
                {
                }
                field("Production Year"; "Production Year")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenVehicleCard)
            {
                Caption = 'Vehicle Card';
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MESSAGE('Open vehicle card.');
                end;
            }
        }
    }
}

