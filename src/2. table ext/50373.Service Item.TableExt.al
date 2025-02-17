tableextension 50373 tableextension50373 extends "Service Item"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Item No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Active Contracts"(Field 28)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Name"(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Address"(Field 57)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Address 2"(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Post Code"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to City"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Contact"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Phone No."(Field 62)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Usage (Cost)"(Field 63)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Usage (Amount)"(Field 64)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Invoiced Amount"(Field 65)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Quantity"(Field 66)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Qty. Invoiced"(Field 67)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Resources Used"(Field 68)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Parts Used"(Field 69)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost Used"(Field 70)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 73)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Service Item Components"(Field 74)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 76)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to County"(Field 78)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contract Cost"(Field 79)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Country/Region Code"(Field 82)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Ship-to Name 2"(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prepaid Amount"(Field 87)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Qty. Consumed"(Field 90)".

        field(50001;"Blocked By VFD";Boolean)
        {
        }
        field(50106;Blocked;Boolean)
        {
            Caption = 'Blocked';
            Description = 'DMS19.00';

            trigger OnValidate()
            var
                Err: Label '%1 must have a value to block the service item %2.';
                UserSetup: Record "91";
                Err2: Label 'You do not have the permission to block Service Items.';
                ServMgmt: Codeunit "50017";
            begin
                //Agile RD FEB 6 2017
                UserSetup.GET(USERID);
                IF NOT UserSetup."Allow to block service item" THEN
                  ERROR(Err2);
                IF "Reason To Block/Unblock" = '' THEN
                  ERROR(Err,FIELDCAPTION("Reason To Block/Unblock"),"Serial No.");
                ServLogMgt.ServiceitemBlockedUnblocked(Rec,xRec);
                //Agile RD FEB 6 2017
            end;
        }
        field(50124;"Reason To Block/Unblock";Text[100])
        {

            trigger OnValidate()
            var
                UserSetup: Record "91";
                Err: Label '%1 must have a value to block the service item %2.';
                Err2: Label 'You do not have the permission to block Service Items.';
            begin
                //Agile RD FEB 6 2017
                UserSetup.GET(USERID);
                IF NOT UserSetup."Allow to block service item" THEN
                  ERROR(Err2);
                //ServLogMgt.ServiceitemReasonChanged(Rec,xRec); //Min
                //Agile RD FEB 6 2017
            end;
        }
        field(50150;"Insurance Start Date";Date)
        {

            trigger OnValidate()
            begin
                //UpdateRVDInsuranceDetail; //Min
            end;
        }
        field(50151;"Insurance End Date";Date)
        {

            trigger OnValidate()
            begin
                //UpdateRVDInsuranceDetail;//Min
            end;
        }
        field(50152;"Insurance Policy No.";Text[50])
        {

            trigger OnValidate()
            begin
                //UpdateRVDInsuranceDetail;
            end;
        }
    }
}

