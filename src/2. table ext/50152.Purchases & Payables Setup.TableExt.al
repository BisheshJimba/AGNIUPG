tableextension 50152 tableextension50152 extends "Purchases & Payables Setup"
{
    // 06.10.2016 EB.P7 #PAR28
    //   Added field:
    //     25006004 "Auto Apply Replacements"
    // 
    // 09.06.2014 Elva Baltic P1 #F0001 EDMS7.10
    //   * Added field:
    //     "Split Order By Price Type"
    // 
    // 21.06.2007. EDMS P2
    //   * Added new fields
    //     Don't Control Vendor Inv. No.
    // 
    // 13.06.2007. EDMS P2
    //   * Added new fields
    //      Presentation Costs
    //      Presentation Costs For VAT 1
    //      Presentation Costs For VAT 2
    //      Pres. Gen. Prod. posting Group 1
    //      Pres. Gen. Prod. posting Group 2
    fields
    {
        modify("Debit Acc. for Non-Item Lines")
        {
            TableRelation = "G/L Account" WHERE(Direct Posting=CONST(Yes),
                                                 Account Type=CONST(Posting),
                                                 Blocked=CONST(No));
        }
        modify("Credit Acc. for Non-Item Lines")
        {
            TableRelation = "G/L Account" WHERE(Direct Posting=CONST(Yes),
                                                 Account Type=CONST(Posting),
                                                 Blocked=CONST(No));
        }
        field(50000; "Requisition No."; Code[10])
        {
            Description = 'Store Requisition No.';
            TableRelation = "No. Series";
        }
        field(50001; "Summary No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50002; "Veh. Registration No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50003; "Chassis. Reg. Account (CV)"; Code[20])
        {
            Description = '//Veh Registration';
            TableRelation = "G/L Account";
        }
        field(50004; "Tax Account (CV)"; Code[20])
        {
            Description = '//Veh Registration';
            TableRelation = "G/L Account";
        }
        field(50005; "Chassis. Reg. Account  (PC)"; Code[20])
        {
            Description = '//Veh Registration';
            TableRelation = "G/L Account";
        }
        field(50006; "Tax Account (PC)"; Code[20])
        {
            Description = '//Veh Registration';
            TableRelation = "G/L Account";
        }
        field(50009; "Veh. Fuel Expense No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50010; "GPD Internal Customer"; Code[20])
        {
            TableRelation = Customer;
        }
        field(50050; "TDS Posting Template Name"; Code[10])
        {
            Description = '//TDS post from 81 to 17';
            TableRelation = "Gen. Journal Template";
        }
        field(50051; "TDS Posting Batch Name"; Code[10])
        {
            Description = '//TDS post from 81 to 17';
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(TDS Posting Template Name));
        }
        field(50052; "TDS Posting Source Code"; Code[10])
        {
            Description = '//TDS post from 81 to 17';
            TableRelation = "Source Code";
        }
        field(60003; "Show Description From"; Option)
        {
            OptionCaption = 'Default,Posting Groups';
            OptionMembers = Default,"Posting Groups";
        }
        field(60004; "External Service VAT Book"; Text[50])
        {
        }
        field(60005; "Item Charge Vat Book"; Text[50])
        {
        }
        field(25006000; "Post Reverse VAT On Prepmt."; Boolean)
        {
            Caption = 'Post Reverse VAT On Prepmt.';
        }
        field(25006001; "Def. Ordering Price Type Code"; Code[10])
        {
            Caption = 'Def. Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006002; "Vehicle Purch. Order Grouping"; Option)
        {
            OptionCaption = 'No Grouping,By Vendor';
            OptionMembers = "No Grouping","By Vendor";
        }
        field(25006003; "Split Order By Price Type"; Boolean)
        {
            Caption = 'Create Diff. Order for Diff. Ordering Price Type of Req. Line';
            Description = 'Create Diff. Order for Diff. Ordering Price Type of Req. Line';
        }
        field(25006004; "Auto Apply Replacements"; Boolean)
        {
            Caption = 'Automatically Apply Replacements';
        }
        field(33019831; "Spare Req. No."; Code[10])
        {
            Description = 'Spare Requisition No. Used for Archive Maintaining';
            TableRelation = "No. Series";
        }
        field(33019832; "Coupon Reg. No. Series"; Code[10])
        {
            Description = '//Fuel Coupon Registration';
            TableRelation = "No. Series";
        }
        field(33019833; "New Vehicle Account (CVD)"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019834; "Office Vehicle Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019835; "Employee as Facility Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019836; "Employee as Advance Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019837; "Generator Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019838; "Stock Issue Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019839; "New Vehicle Account (PCD)"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019840; "Rented Vehicle Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019841; "Demo Vehicle Account"; Code[20])
        {
            Description = '//Fuel Expense';
            TableRelation = "G/L Account";
        }
        field(33019842; "Purch. VAT No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019843; "Posting Group"; Code[100])
        {
        }
        field(33019844; "Exempt Vendor No."; Code[100])
        {
        }
        field(33019873; "Import Purch. Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019874; "Memo Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019875; "Sales Memo Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019876; "Veh. Sales Memo Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }
}

