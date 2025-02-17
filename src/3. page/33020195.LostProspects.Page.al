page 33020195 "Lost Prospects"
{
    PageType = List;
    SourceTable = Table33020143;
    SourceTableView = ORDER(Ascending)
                      WHERE(Master Options=CONST(LostProspect));

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
                field(Active; Active)
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

