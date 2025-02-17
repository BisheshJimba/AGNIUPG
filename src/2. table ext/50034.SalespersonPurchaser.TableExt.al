tableextension 50034 tableextension50034 extends "Salesperson/Purchaser"
{
    // //10-08-2007 EDMS P3
    //    * Changed DK kods back to standart form
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Next To-do Date"(Field 5054)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Opportunities"(Field 5055)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Value (LCY)"(Field 5056)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Current Value (LCY)"(Field 5057)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Interactions"(Field 5059)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost (LCY)"(Field 5060)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Duration (Min.)"(Field 5061)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Avg. Estimated Value (LCY)"(Field 5068)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Avg.Calcd. Current Value (LCY)"(Field 5069)".

        // modify("Contact Company Filter")//commented by ucr
        // {
        // TableRelation = Contact WHERE(Type = CONST(""));//no blank option in type
        // }

        //Unsupported feature: Property Modification (CalcFormula) on ""Opportunity Entry Exists"(Field 5082)".


        //Unsupported feature: Property Modification (CalcFormula) on ""To-do Entry Exists"(Field 5083)".

        field(50000; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = IF ("Vehicle Division" = CONST(CVD)) Make.Code WHERE(Code = CONST('TATA CVD'))
            ELSE IF ("Vehicle Division" = CONST(PCD)) Make.Code WHERE(Code = CONST('TATA PCD'))
            ELSE IF ("Vehicle Division" = CONST(" ")) Make.Code;
        }
        field(50001; "Model Code"; Code[100])
        {
            Caption = 'Model Code';
            Description = 'CNY.CRM';

            trigger OnLookup()
            begin
                // CNY.CRM >>
                Model_G.RESET;
                Model_G.SETRANGE("Make Code", "Make Code");
                IF PAGE.RUNMODAL(0, Model_G) = ACTION::LookupOK THEN BEGIN
                    IF "Model Code" = '' THEN
                        "Model Code" := Model_G.Code
                    ELSE
                        "Model Code" := "Model Code" + '|' + Model_G.Code;
                END;
                // CNY.CRM <<
            end;
        }
        field(50002; "Resource Group"; Code[10])
        {
            Description = 'CNY.CRM';
            TableRelation = "Resource Group";
        }
        field(50003; "Outstanding Cr Amt"; Decimal)
        {
            Description = 'HP2.0';
            // FieldClass = FlowField;
            // CalcFormula = Sum("Vehicle Finance Header"."Total Due" WHERE("Responsible Person Code"=FIELD(Code),
            //                                                               "Loan Disbursed"=CONST(true),
            //                                                               Closed=CONST(false),
            //                                                               Rejected=CONST(false),
            //                                                               "Total Due"=FILTER(<>0)));//need to solve table error
        }
        field(50004; "M Skill"; Code[20])
        {
            Description = 'PSF';
        }
        field(50010; "Accountability Center"; Code[20])
        {
            TableRelation = "Accountability Center";
        }
        field(33020142; "Vehicle Division"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;

            trigger OnValidate()
            begin
                IF "Vehicle Division" = "Vehicle Division"::PCD THEN
                    "Make Code" := 'TATA PCD'
                ELSE IF "Vehicle Division" = "Vehicle Division"::CVD THEN
                    "Make Code" := 'TATA CVD';
            end;
        }
        field(33020143; "Is Dealer"; Boolean)
        {
        }
        field(33020144; "Area"; Code[10])
        {
            TableRelation = Area.Code;
        }
        field(33020145; "SP for Vehicle"; Boolean)
        {
            Description = 'check if the salesperson is related to vehicle sales only';
        }
        field(33020146; "Dealer Information"; Text[50])
        {
        }
    }
    keys
    {
        key(Key1; "Area")
        {
        }
        // key(Key2;Name)//name does not exist
        // {
        // }
    }


    //Unsupported feature: Code Modification on "CreateInteraction(PROCEDURE 10)".

    //procedure CreateInteraction();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TempSegmentLine.CreateInteractionFromSalesPurc(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TempSegmentLine.CreateInteractionFromSalesPurc(Rec);
    //Upgrade 2017 >>
    //10-08-2007 JF EB LV DMS
    //SegmentLine."Time of Interaction" := TIME;
    //Upgrade 2017 <<
    */
    //end;

    //Unsupported feature: Insertion (FieldGroupCollection) on "(FieldGroup: DropDown)".


    var
        Model_G: Record Model;
}

