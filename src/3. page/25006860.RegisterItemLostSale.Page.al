page 25006860 "Register Item Lost Sale"
{
    Caption = 'Register Item Lost Sale';
    PageType = Card;
    Permissions = TableData 25006747 = rimd;

    layout
    {
        area(content)
        {
            field(Date; Date)
            {
                Caption = 'Date';
            }
            field(CustomerNo; CustomerNo)
            {
                Caption = 'Customer No.';
                TableRelation = Customer;
            }
            field(ItemNo; ItemNo)
            {
                Caption = 'Item No.';
                TableRelation = Item;
            }
            field(Quantity; Quantity)
            {
                Caption = 'Quantity';
            }
            field(Desc; Desc)
            {
                Caption = 'Description';
            }
            field(Desc2; Desc2)
            {
                Caption = 'Description 2';
            }
            field(ReasonCode; ReasonCode)
            {
                Caption = 'Reason Code';
                TableRelation = "Lost Sales Reason";
            }
            field(Importance; Importance)
            {
                Caption = 'Priority';
                OptionCaption = ' ,Highest,High,Mediun,Low,Lowest';
            }
            field(LocationCode; LocationCode)
            {
                Caption = 'Location Code';
                Editable = false;
                TableRelation = Location;
            }
            field(AssignUserId; AssignUserId)
            {
                Caption = 'Assign User Id';
                Editable = false;
            }
            field(Advance; Advance)
            {
                Caption = 'Advance';
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean
    begin
        AssignUserId := USERID;
    end;

    trigger OnOpenPage()
    var
        US: Record "91";
    begin
        Date := WORKDATE;
        AssignUserId := USERID;
        IF US.GET(USERID) THEN
            LocationCode := US."Default Location";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::OK THEN
            YesOnPush;
    end;

    var
        CustomerNo: Code[20];
        Date: Date;
        ItemNo: Code[20];
        Desc: Text[30];
        Desc2: Text[30];
        ReasonCode: Code[20];
        ReasonDesc: Text[30];
        LostSalesMgt: Codeunit "25006504";
        Importance: Option " ",Highest,High,Mediun,Low,Lowest;
        LocationCode: Text[30];
        AssignUserId: Code[50];
        Advance: Boolean;
        Quantity: Decimal;

    [Scope('Internal')]
    procedure SetItem(PItemNo: Code[20])
    begin
        ItemNo := PItemNo;
    end;

    [Scope('Internal')]
    procedure SetCustomer(CustomerNo1: Code[20])
    begin
        CustomerNo := CustomerNo1;
    end;

    local procedure YesOnPush()
    begin
        IF Quantity = 0 THEN
            ERROR('Quantity is Blank.');
        IF CustomerNo = '' THEN
            ERROR('Customer No. is empty.');
        IF ItemNo = '' THEN
            ERROR('Item No. is empty.');
        IF ReasonCode = '' THEN
            ERROR('Reason Code Must have a value.');
        IF Importance = Importance::" " THEN
            ERROR('Priority must have a value.');
        LostSalesMgt.CreateEntry_Item(Date, ItemNo, CustomerNo, Desc, Desc2, ReasonCode, Importance, FALSE, Advance, Quantity);
    end;
}

