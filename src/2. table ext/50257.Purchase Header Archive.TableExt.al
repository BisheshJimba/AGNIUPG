tableextension 50257 tableextension50257 extends "Purchase Header Archive"
{
    // 20.02.2015 EB.P7 #Arch Ret.Ord.
    //   Renewed EDMS fields from Purchase Header
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name 2"(Field 6)".


        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 60)".


        //Unsupported feature: Property Insertion (Editable) on "Amount(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount Including VAT"(Field 61)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name 2"(Field 80)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Archived Versions"(Field 145)".

        modify("Purchase Quote No.")
        {
            TableRelation = "Purchase Header".No. WHERE(Document Type=CONST(Quote),
                                                         No.=FIELD(Purchase Quote No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Received"(Field 5752)".

        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006020; "Auto Created Doc"; Boolean)
        {
            Caption = 'Auto Created Document';
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = true;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(33019831; "Order Type"; Option)
        {
            OptionCaption = ' ,Normal,VOR';
            OptionMembers = " ",Normal,VOR;
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011; "System LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(33020012; "Bank LC No."; Code[20])
        {
        }
        field(33020013; "LC Amend No."; Code[20])
        {
        }
        field(33020235; "Service Order No."; Code[20])
        {
            Description = 'Used for External Service Order';
        }
        field(33020601; "Approved User ID"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
    }
    keys
    {
        key(Key1; "Document Profile")
        {
        }
    }
}

