page 50000 Suppliers
{
    PageType = List;
    SourceTable = Supplier;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Purchase Reference No. Series"; Rec."Purchase Reference No. Series")
                {
                }
            }
        }
    }

    actions
    {
    }
}

