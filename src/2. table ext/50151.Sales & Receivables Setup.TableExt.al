tableextension 50151 tableextension50151 extends "Sales & Receivables Setup"
{
    // 26.03.2014 MMG7.1.00 P7 #Marginal VAT
    //   * Added fields: Veh. Marg. VAT Item Charge
    // 
    // 20.03.2013 EDMS P8
    //   * Added fields "Vehicle Service Plan on Sales"
    // 
    // 01.09.2008. EDMS P2
    //   * Added fields "Veh.Interdep. Incoming Account"
    //                  "Veh.Interdep. Expenses Account"
    // 
    // 09.05.2008. EDMS P2
    //   * Added field "Compress Prepayment"
    // 
    // 27.08.2007. EDMS P2
    //   * Added new field "Contract Nos."
    // 
    // 15.08.2007. EDMS P2
    //   * Added new field "Print Only Posted Doc."
    // 
    // 29.05.2007. EDMS P2
    //   * Added field Trade-In Sales Account No.
    fields
    {
        field(50000; "Vehicle Allotment Header Text"; Text[250])
        {
        }
        field(50001; "Vehicle Allotment Footer Text1"; Text[250])
        {
        }
        field(50002; "Vehicle Allotment Footer Text2"; Text[250])
        {
        }
        field(50003; "Vehicle Insurance Text"; Text[250])
        {
        }
        field(50004; "Veh. Insurance Payment Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50005; "Veh. Dispatch No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50006; "Activate SMS System"; Boolean)
        {
        }
        field(50007; "Vehicle Allocation Due Date"; Decimal)
        {
        }
        field(55000; "Def. Taxable VAT Bus. Code"; Code[20])
        {
            Caption = 'Def. Taxable VAT Prod. Code';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(55001; "Def. NonTaxable VAT Bus. Code"; Code[20])
        {
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(55011; "Enable Sales Synchronization"; Boolean)
        {
        }
        field(55050; "Def. Sales VAT %"; Decimal)
        {
        }
        field(55051; "LC Validity Days"; Integer)
        {
        }
        field(55052; "DO Validity Days"; Integer)
        {
        }
        field(55053; "Agni Corporate Location"; Code[20])
        {
            TableRelation = Location;
        }
        field(55054; "Tender Validity Days"; Integer)
        {
        }
        field(55060; "Purchase Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55061; "LC Vendor A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55062; "Goods In Transit A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55063; "Bills on LC A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(55064; "Dispatch Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(55065; "Dispatch Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Dispatch Template Name));
        }
        field(55066; "Toatl Amt. as Qty-to Ship"; Boolean)
        {
        }
        field(55067; "External Service VAT Book"; Text[50])
        {
        }
        field(60003; "Show Description From"; Option)
        {
            OptionCaption = 'Default,Posting Groups';
            OptionMembers = Default,"Posting Groups";
        }
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006010; "Trade-In Sales Account No."; Code[20])
        {
            Caption = 'Trade-In Sales Account No.';
            TableRelation = "G/L Account";
        }
        field(25006014; "Veh. Marginal VAT Account No."; Code[20])
        {
            Caption = 'Veh. Marginal VAT Account No.';
            TableRelation = "G/L Account";
        }
        field(25006015; "Payment Method Mandatory"; Boolean)
        {
            Caption = 'Payment Method Mandatory';
        }
        field(25006016; "Veh. Marg.VAT Gen.Bus.Grp."; Code[20])
        {
            Caption = 'Veh. Marg.VAT Gen.Bus.Posting Grp.';
            TableRelation = "Gen. Business Posting Group";
        }
        field(25006018; "Veh. Marg.VAT Gen.Prod.Grp."; Code[10])
        {
            Caption = 'Veh. Marg.VAT Gen.Prod.Posting Grp.';
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006030; "Vehicle Warranty on Sales"; Boolean)
        {
            Caption = 'Vehicle Warranty on Sales';
        }
        field(25006031; "Vehicle Service Plan on Sales"; Boolean)
        {
        }
        field(25006150; "Vehicle Sales Item Charge"; Code[20])
        {
            Caption = 'Vehicle Sales Item Charge';
            TableRelation = "Item Charge".No.;
        }
        field(25006170; "Contract Nos."; Code[10])
        {
            Caption = 'Contract Nos.';
            TableRelation = "No. Series";
        }
        field(25006190; "Def. Sales Price Include VAT"; Boolean)
        {
            Caption = 'Def. Sales Price Include VAT';
        }
        field(25006196; "Item No. Replacement Warnings"; Boolean)
        {
            Caption = 'Item No. Replacement Warnings';
        }
        field(25006200; "Def.S.Price VAT Bus.Post.Grp."; Code[10])
        {
            Caption = 'Def. Sales Price VAT Bus. Post. Grp.';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(25006210; "Def.S.Price VAT Prod.Post.Grp."; Code[10])
        {
            Caption = 'Def. Sales Price VAT Prod. Post. Grp.';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(25006220; "Def.Sales Price AllowLineDisc."; Boolean)
        {
            Caption = 'Def. Sales Price Allow Line Disc.';
        }
        field(25006230; "Def.Sales Price Include Disc."; Boolean)
        {
            Caption = 'Def. Sales Price Include Disc.';
        }
        field(25006240; "Def.S.Price Currency Code"; Code[10])
        {
            Caption = 'Def. Sales Price Currency Code';
            TableRelation = Currency.Code;
        }
        field(25006260; "Def.S.Price Rounding Precision"; Decimal)
        {
            Caption = 'Def. Sales Price Rounding Precision';
        }
        field(25006270; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
        }
        field(25006300; "Def.Vehicle-Contact Rel."; Code[10])
        {
            Caption = 'Def.Vehicle-Contact Rel.';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006310; "Offer Link Vehicle and Contact"; Boolean)
        {
            Caption = 'Offer Link Vehicle and Contact';
        }
        field(25006320; "Link Relationship Code"; Code[10])
        {
            Caption = 'Link Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(25006330; "Veh. Marg. VAT Item Charge"; Code[20])
        {
            Caption = 'Veh. Marg. VAT Item Charge';
            TableRelation = "Item Charge";
        }
        field(25006419; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(33019810; "Advance Booking Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Advance Booking Template));
        }
        field(33019811; "Advance Booking Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(33019812; "Rev Adv Booking Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(Rev Adv  Booking Template));
        }
        field(33019813; "Rev Adv  Booking Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(33019814; "Custom Application Location 1"; Code[10])
        {
            TableRelation = Location;
        }
        field(33019815; "Profit % Local Parts"; Decimal)
        {
        }
        field(33019816; "NDP Factor (%)"; Decimal)
        {
        }
        field(33019817; "Accessories CVD Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(33019818; "Accessories PCD Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(33019819; "Accessories Issue No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019820; "Custom Application Location 2"; Code[10])
        {
            TableRelation = Location;
        }
        field(33019821; "Commercial Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019822; "Dimensionwise Cr. Limit Check"; Boolean)
        {
        }
        field(33019823; "Margin Percentage"; Decimal)
        {
        }
        field(33019824; "Interest Percentage"; Decimal)
        {
        }
        field(33019825; "Interest Calculate Days"; Integer)
        {
        }
        field(33019826; "QR Code"; BLOB)
        {
            SubType = Bitmap;
        }
    }
}

