tableextension 50047 tableextension50047 extends Location
{
    // 14.05.2007. EDMS P2
    //   *Added new flowfields "Transfered (LCY)"
    // 
    // 10.05.2007 EDMS P2
    //   *Added new fields "Data filter", "Item Type Filter", "Net Change(LCY)", "Purchases(LCY)"
    //   *Added new fields "Positive Adjmt.(LCY)", "Negative Adjmt. (LCY)", "COGS (LCY)"
    fields
    {
        modify(City)
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        modify("Post Code")
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
        }
        field(50000; "Admin/Procurement"; Boolean)
        {
        }
        field(50001; "Default Price Group"; Code[10])
        {
            TableRelation = "Customer Price Group".Code;
        }
        field(70000; "QR Mandatory"; Boolean)
        {
            Description = 'SRT,QR19.00';
        }
        field(70001; "Check QR Excess Qty."; Boolean)
        {
            Description = 'SRT,QR19.00';
        }
        field(25006005; "Net Change (LCY)"; Decimal)
        {
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006010; "Purchases (LCY)"; Decimal)
        {
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Item Ledger Entry Type" = CONST(Purchase),
                                                                          "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006020; "Positive Adjmt. (LCY)"; Decimal)
        {
            Caption = 'Positive Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Item Ledger Entry Type" = CONST("Positive Adjmt."),
                                                                          "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006030; "Negative Adjmt. (LCY)"; Decimal)
        {
            Caption = 'Negative Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = - Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Item Ledger Entry Type" = CONST("Negative Adjmt."),
                                                                           "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006040; "COGS (LCY)"; Decimal)
        {
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = - Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Item Ledger Entry Type" = CONST(Sale),
                                                                           "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006050; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006060; "Item Type Filter"; Option)
        {
            Caption = 'Item Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Model Version,Own Option,Material';
            OptionMembers = " ",Item,"Model Version","Own Option",Material;
        }
        field(25006070; "Transfered (LCY)"; Decimal)
        {
            Caption = 'Transfered (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Location Code" = FIELD(Code),
                                                                          "Item Ledger Entry Type" = CONST(Transfer),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Item Type" = FIELD("Item Type Filter")));
        }
        field(25006240; "Use As Service Location"; Boolean)
        {
            Caption = 'Use As Service Location';
        }
        field(33019831; "Use As Store"; Boolean)
        {
        }
        field(33019832; "Sales Quote Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019833; "Sales Blanket Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019834; "Sales Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019835; "Sales Return Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019836; "Sales Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019837; "Sales Posted Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019838; "Sales Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019839; "Sales Posted Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019840; "Sales Posted Shipment Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019841; "Purch. Quote Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019842; "Purch. Blanket Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019843; "Purch. Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019844; "Purch. Return Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019845; "Purch. Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019846; "Purch. Posted Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019847; "Purch. Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019848; "Purch. Posted Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019849; "Purch. Posted Receipt Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019850; "Serv. Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019851; "Serv. Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019852; "Serv. Posted Invoice Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019853; "Serv. Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019854; "Serv. Posted Credit Memo Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019855; "Trans. Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019856; "Posted Transfer Shpt. Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019857; "Posted Transfer Rcpt. Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019858; "Purch. Posted Prept. Inv. Nos."; Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019859; "Purch. Ptd. Prept. Cr. M. Nos."; Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019860; "Purch. Ptd. Return Shpt. Nos."; Code[10])
        {
            Caption = 'Purch. Posted Return Shpt. Nos.';
            TableRelation = "No. Series";
        }
        field(33019861; "Sales Posted Prepmt. Inv. Nos."; Code[10])
        {
            Caption = 'Sales Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019862; "Sales Ptd. Prept. Cr. M. Nos."; Code[10])
        {
            Caption = 'Sales Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019863; "Sales Ptd. Return Receipt Nos."; Code[10])
        {
            Caption = 'Sales Posted Return Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(33019864; "Serv. Booking Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019865; "Serv. Posted Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019866; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(33019867; "Sales Posted Debit Note Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019868; "PP Mandatory Check"; Boolean)
        {
        }
        field(33019869; "Insurance No. Check"; Boolean)
        {
        }
        field(33019870; "Location Type"; Option)
        {
            OptionCaption = ' ,Vehicle Store (Inside Valley),Vehicle Store (Outside Valley),Showroom';
            OptionMembers = " ","Vehicle Store (Inside Valley)","Vehicle Store (Outside Valley)",Showroom;
        }
        field(33019871; WareHouse; Boolean)
        {
        }
        field(33019872; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
    }
}

