page 33020141 "C2 Sub Stage Lists"
{
    PageType = List;
    SourceTable = Table33020152;
    SourceTableView = SORTING(Prospect No., Code);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Done; Done)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        IF UserSetup_G.GET(USERID) THEN
            IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN
                SETRANGE("Division Type", SalesPerson_G."Vehicle Division");
        FILTERGROUP(0);
    end;

    var
        UserSetup_G: Record "91";
        SalesPerson_G: Record "13";
}

