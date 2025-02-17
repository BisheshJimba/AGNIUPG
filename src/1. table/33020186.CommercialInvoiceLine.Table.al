table 33020186 "Commercial Invoice Line"
{

    fields
    {
        field(1; "Sales Invoice No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Sales Invoice No." <> '' THEN BEGIN
                    SalesInvHeader.GET("Sales Invoice No.");
                    SalesInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                    Amount := SalesInvHeader.Amount;
                END;
            end;
        }
        field(2; "Document No."; Code[20])
        {
            TableRelation = "Commercial Invoice Header";
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Proforma Date"; Date)
        {
        }
        field(5; "Proforma No."; Code[20])
        {
        }
        field(5000; "Desc. of Goods/Services in LC"; Text[250])
        {
            Caption = 'Description of Goods/Services in LC';
        }
        field(5001; "Proforma No. Second"; Text[250])
        {
        }
        field(5002; "Proforma Date Second"; Text[250])
        {
        }
        field(5003; Amount; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //ratan 4.27.2021>> check if sales invoice already exist
        /*CommercialInvLine.RESET;
        CommercialInvLine.SETRANGE("Sales Invoice No.","Sales Invoice No.");
        IF CommercialInvLine.FINDFIRST THEN
          ERROR('Commercial sales inv line already exist with sales invoice no %1',"Sales Invoice No.");*/

    end;

    var
        CommercialInvLine: Record "33020186";
        SalesInvHeader: Record "112";
        CommercialLine: Record "33020186";

    [Scope('Internal')]
    procedure GetCurrencyCode(): Code[10]
    var
        CommercialInvHdr: Record "33020185";
    begin
        /*
        IF xRec."Sales Invoice No." = CommercialInvHdr.No THEN
          EXIT(CommercialInvHdr."Currency Code");
        IF CommercialInvHdr.GET("Sales Invoice No.") THEN
          EXIT(CommercialInvHdr."Currency Code");
        EXIT('');
        */

    end;
}

