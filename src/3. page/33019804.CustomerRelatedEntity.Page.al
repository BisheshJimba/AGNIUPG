page 33019804 "Customer Related Entity"
{
    CardPageID = "Customer RE Card";
    PageType = List;
    SourceTable = Table33019804;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Related Entity No."; "Related Entity No.")
                {
                }
                field("Related Entities Name"; "Related Entities Name")
                {
                }
                field("RE Company Registration No."; "RE Company Registration No.")
                {
                    Caption = 'Related Entity Company Registration No.';
                }
                field("RE Comp Reg No Issued Auth"; "RE Comp Reg No Issued Auth")
                {
                    Caption = 'Related Entity Comp Reg No Issued Auth';
                }
                field("RE Citizenship No"; "RE Citizenship No")
                {
                    Caption = 'Related Entity Citizenship No.';
                }
                field("RE Prev Citizenship No"; "RE Prev Citizenship No")
                {
                    Caption = 'Related Entity Previous Citizenship No';
                }
                field("RE Citizenship No Issued Date"; "RE Citizenship No Issued Date")
                {
                    Caption = 'Related Entity Citizenship No Issued Date';
                }
                field("RE Citizenship No Issued Distr"; "RE Citizenship No Issued Distr")
                {
                    Caption = 'Related Entity Citizenship No Issued District';
                }
                field("BR RE Type"; "BR RE Type")
                {
                    Caption = 'Business Relation Related Entity Type';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF CusNo <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Customer No.", CusNo);
            FILTERGROUP(0);
        END;
    end;

    var
        CusNo: Code[20];

    [Scope('Internal')]
    procedure setCustomer(Cus: Code[20])
    begin
        CusNo := Cus;
    end;
}

