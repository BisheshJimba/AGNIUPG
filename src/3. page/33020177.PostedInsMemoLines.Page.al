page 33020177 "Posted Ins. Memo Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
                field(Canceled; Canceled)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159018>")
            {
                Caption = 'Cancel Insurance';
                RunObject = Page 33020189;
                RunPageLink = Insurance Memo No.=FIELD(Reference No.), Vehicle Serial No.=FIELD(Vehicle Serial No.);
            }
        }
    }
}

