tableextension 50119 tableextension50119 extends "VAT Entry"
{
    fields
    {
        modify("Bill-to/Pay-to No.")
        {
            TableRelation = IF (Type = CONST(Purchase)) Vendor
            ELSE
            IF (Type = CONST(Sale)) Customer;
        }
        modify("Ship-to/Order Address Code")
        {
            TableRelation = IF (Type = CONST(Purchase)) "Order Address".Code WHERE(Vendor No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Type=CONST(Sale)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.));
        }
        field(50000;"Capital Expenditure";Boolean)
        {
        }
        field(50001;"Import Invoice No.";Code[20])
        {
            TableRelation = "Purch. Inv. Header".No.;
        }
        field(50500;"G/L Entry No.";Integer)
        {
            CalcFormula = Lookup("G/L Entry - VAT Entry Link"."G/L Entry No." WHERE (VAT Entry No.=FIELD(Entry No.)));
            Description = 'To compare with Field no. 50501 data (for VAT report)';
            FieldClass = FlowField;
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(50501;"G/L Account No.";Code[20])
        {
            CalcFormula = Lookup("G/L Entry"."G/L Account No." WHERE (Transaction No.=FIELD(Transaction No.),
                                                                      Amount=FIELD(Amount),
                                                                      Document No.=FIELD(Document No.)));
            Description = 'For VAT report';
            FieldClass = FlowField;
        }
        field(50502;"Item Ldgr No (Exempt Purchase)";Integer)
        {
            CalcFormula = Max("Value Entry"."Item Ledger Entry No." WHERE (Document No.=FIELD(Document No.),
                                                                           Source No.=FILTER(V0344|V0337|LCV*),
                                                                           Inventory Posting Group=CONST(M&MTRACTOR)));
            Description = 'For VAT report (basis to add Custom & Commerical Invoice of M&M Tractor)';
            FieldClass = FlowField;
        }
        field(50503;"PP No. (Exempt Purchase)";Code[20])
        {
            CalcFormula = Lookup("Value Entry"."External Document No." WHERE (Source No.=FILTER(V0337),
                                                                              Item Ledger Entry No.=FIELD("Item Ldgr No (Exempt Purchase)")));
            Description = 'For VAT report (basis to add Custom & Commerical Invoice of M&M Tractor)';
            FieldClass = FlowField;
        }
        field(50504;"Exempt Purchase No.";Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(50505;"Total Amt";Decimal)
        {
            CalcFormula = Sum("VAT Entry".Base WHERE (Exempt Purchase No.=FIELD(Exempt Purchase No.),
                                                      Bill-to/Pay-to No.=FILTER(<>V0350),
                                                      Document No.=FIELD(Document No.),
                                                      Amount=CONST(0)));
            FieldClass = FlowField;
        }
        field(50506;"Pragyapan Patra No.";Code[20])
        {
        }
        field(50507;"Localized VAT Identifier";Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
    }
    keys
    {
        key(Key1;"Document No.")
        {
        }
        key(Key2;"Bill-to/Pay-to No.")
        {
        }
        key(Key3;"Document No.","Exempt Purchase No.","Posting Date")
        {
        }
        key(Key4;"Exempt Purchase No.","Bill-to/Pay-to No.")
        {
            SumIndexFields = Base;
        }
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 5)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CopyPostingGroupsFromGenJnlLine(GenJnlLine);
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        #4..15
        "Bill-to/Pay-to No." := GenJnlLine."Bill-to/Pay-to No.";
        "Country/Region Code" := GenJnlLine."Country/Region Code";
        "VAT Registration No." := GenJnlLine."VAT Registration No.";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..18

        "Exempt Purchase No." := GenJnlLine."Exempt Purchase No."; //***SM 13 Jan 2014 to pass Exempt no. in vat entry
        "Import Invoice No." := GenJnlLine."Import Invoice No.";
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset") AND
            (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::"Acquisition Cost") THEN
          "Capital Expenditure" := TRUE;
        "Localized VAT Identifier" := GenJnlLine."Localized VAT Identifier";//aakrista
        */
    //end;
}

