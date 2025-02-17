table 33020435 "Dealer Contact"
{
    Caption = 'Dealer Contact';

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
        }
        field(10; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(30; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(31; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(32; Salesperson; Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
        field(33;"Prospect Date";Date)
        {
        }
        field(34;"Contact Code";Code[20])
        {

            trigger OnValidate()
            var
                Contact: Record "5050";
                ContactBusinessRelation: Record "5054";
                MarketingSetup: Record "5079";
            begin
            end;
        }
        field(35;"Contact Name";Text[50])
        {
            Editable = false;
        }
        field(37;"Make Code";Code[20])
        {
        }
        field(38;"Model Code";Code[20])
        {
        }
        field(39;"Model Version Code";Code[20])
        {
        }
        field(40;"Preferred Color";Code[20])
        {
        }
        field(41;VIN;Code[20])
        {
            Editable = false;
        }
        field(42;"Registration No.";Code[20])
        {
            Editable = false;
        }
        field(50;Status;Option)
        {
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(51;"Customer Code";Code[20])
        {
            Editable = false;

            trigger OnValidate()
            var
                Customer: Record "18";
                MarketingSetup: Record "5079";
                ContactBusinessRelation: Record "5054";
            begin
            end;
        }
        field(52;"Customer Name";Text[50])
        {
            Editable = false;
        }
        field(53;Cancelled;Boolean)
        {
            Editable = false;
        }
        field(54;"Cancelled Reason";Text[50])
        {
        }
        field(60;Remarks;Text[250])
        {
        }
        field(72;"Sales Quote No.";Code[20])
        {
            Editable = false;
        }
        field(73;"Sales Order No.";Code[20])
        {
            Editable = false;
        }
        field(74;"Posted Sales Invoice No.";Code[20])
        {
            Editable = false;
        }
        field(75;"Sales Return Order No.";Code[20])
        {
            Editable = false;
        }
        field(76;"Posted Sales Cr. Memo No.";Code[20])
        {
            Editable = false;
        }
        field(5000;"Customer Booking Amount";Decimal)
        {
            Editable = false;
        }
        field(5001;"Finance Amount";Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(5002;"Finance By";Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record "18";
            begin
            end;
        }
        field(5003;"Customer Balance Amount";Decimal)
        {
            Editable = false;
        }
        field(5004;"Remaining Balance";Decimal)
        {
        }
        field(5005;"Finance By Name";Text[50])
        {
            Editable = false;
        }
        field(5006;"Dealer Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Dealer Code","Prospect No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Prospect No.",Field2,Field5050,Field7,Field91,Field9)
        {
        }
    }

    trigger OnDelete()
    var
        Todo: Record "5080";
        SegLine: Record "5077";
        ContIndustGrp: Record "5058";
        ContactWebSource: Record "5060";
        ContJobResp: Record "5067";
        ContMailingGrp: Record "5056";
        ContProfileAnswer: Record "5089";
        RMCommentLine: Record "5061";
        ContAltAddr: Record "5051";
        ContAltAddrDateRange: Record "5052";
        InteractLogEntry: Record "5065";
        Opp: Record "5092";
        CampaignTargetGrMgt: Codeunit "7030";
        VATRegistrationLogMgt: Codeunit "249";
    begin
    end;
}

