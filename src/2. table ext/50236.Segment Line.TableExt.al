tableextension 50236 tableextension50236 extends "Segment Line"
{
    // 10.11.2015 EB.P30 #T065
    //   Added field "Vehicle Serial No."
    // 
    // 17.07.2013 EDMS P8
    //   * added fenction ShowContactVehicles, GetFirstVehicleNo
    // 
    // 01-08-2007 EDMS P3
    //   * AutoFill of description on interaction template change
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""Contact Name"(Field 12)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Contact Company Name"(Field 18)".

        modify(Description)
        {

            //Unsupported feature: Property Modification (Data type) on "Description(Field 22)".

            Description = ' Previous length is 50';
        }


        //Unsupported feature: Code Modification on ""Interaction Template Code"(Field 7).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Contact No.");
        Cont.GET("Contact No.");
        "Attachment No." := 0;
        #4..51
          "Campaign Target" := InteractTmpl."Campaign Target";
          "Campaign Response" := InteractTmpl."Campaign Response";

          CASE TRUE OF
            SegHeader."Ignore Contact Corres. Type" AND
            (SegHeader."Correspondence Type (Default)" <> SegHeader."Correspondence Type (Default)"::" "):
              "Correspondence Type" := SegHeader."Correspondence Type (Default)";
            InteractTmpl."Ignore Contact Corres. Type" OR
            ((InteractTmpl."Ignore Contact Corres. Type" = FALSE) AND
             (Cont."Correspondence Type" = Cont."Correspondence Type"::" ") AND
             (InteractTmpl."Correspondence Type (Default)" <> InteractTmpl."Correspondence Type (Default)"::" ")):
              "Correspondence Type" := InteractTmpl."Correspondence Type (Default)";
            ELSE
              IF Cont."Correspondence Type" <> Cont."Correspondence Type"::" " THEN
                "Correspondence Type" := Cont."Correspondence Type"
        #67..76
          "Campaign Description" := Campaign.Description;

        MODIFY;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..54
          IF Description = '' THEN
            Description := InteractTmpl.Description; //01-08-2007 EDMS P3

          CASE TRUE OF
            SegHeader."Ignore Contact Corres. Type" AND
            (SegHeader."Correspondence Type (Default)" <> SegHeader."Correspondence Type (Default)"::" ") :
              "Correspondence Type" := SegHeader."Correspondence Type (Default)";

        #59..61
             (InteractTmpl."Correspondence Type (Default)" <> InteractTmpl."Correspondence Type (Default)"::" ")) :
              "Correspondence Type" := InteractTmpl."Correspondence Type (Default)";

        #64..79
        */
        //end;
        field(50009; "Prospect Line No."; Integer)
        {
            Description = 'CNY.CRM Populate Pipeline Management Details for the Prospect';
            Editable = false;
        }
        field(50010; "Model Version No."; Code[20])
        {
            Description = 'CNY.CRM Populate Pipeline Management Details for the Prospect';

            trigger OnLookup()
            begin
                // CNY.CRM >>
                // PipeLineMgmt_G.RESET;
                // IF "Salesperson Code" <> '' THEN
                //  PipeLineMgmt_G.SETRANGE("Salesperson Code","Salesperson Code")
                // ELSE
                //  PipeLineMgmt_G.SETRANGE("Prospect No.","Contact No.");
                //
                // IF PAGE.RUNMODAL(33020135,PipeLineMgmt_G) = ACTION :: LookupOK THEN BEGIN
                //  "Model Vesion No." := PipeLineMgmt_G."Model Version No.";
                //  "Prospect Line No." := PipeLineMgmt_G."Line No.";
                //  "Salesperson Code" := PipeLineMgmt_G."Salesperson Code";
                //  "Wizard Contact Name" := PipeLineMgmt_G."Company Name";
                //  "Contact No." := PipeLineMgmt_G."Prospect No.";
                //  "Contact Company No." := PipeLineMgmt_G."Company No.";
                // END;
                // CNY.CRM <<
            end;
        }
        field(25006000; "Vehicle Serial No. -Not Used"; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Delete it -UPG';
            TableRelation = Vehicle;
        }
        field(25006010; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006020; "Vehicles Count"; Integer)
        {
            CalcFormula = Count("Segment SubLine" WHERE(Segment No.=FIELD(Segment No.),
                                                         Line No.=FIELD(Line No.)));
            Description = 'Make it 25006000 -UPG';
            FieldClass = FlowField;
        }
        field(25006021;Remarks;Text[150])
        {
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: SegmentSubLine)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CampaignTargetGrMgt.DeleteSegfromTargetGr(Rec);

        SegInteractLanguage.RESET;
        #4..26
            Todo.MODIFYALL("Segment No.",'');
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..29
        SegmentSubLine.RESET;
        SegmentSubLine.SETRANGE("Segment No.", "Segment No.");
        SegmentSubLine.SETRANGE("Line No.", "Line No.");
        SegmentSubLine.DELETEALL(TRUE);
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: UserSetup) (VariableCollection) on "CreateInteractionFromContact(PROCEDURE 38)".


    //Unsupported feature: Variable Insertion (Variable: PurchSlsPer) (VariableCollection) on "CreateInteractionFromContact(PROCEDURE 38)".



    //Unsupported feature: Code Modification on "CreateInteractionFromContact(PROCEDURE 38)".

    //procedure CreateInteractionFromContact();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        DELETEALL;
        INIT;
        IF Contact.Type = Contact.Type::Person THEN
          SETRANGE("Contact Company No.",Contact."Company No.");
        SETRANGE("Contact No.",Contact."No.");
        VALIDATE("Contact No.",Contact."No.");
        "Salesperson Code" := Contact."Salesperson Code";
        StartWizard;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        //28.01.2008 EDMS P3 >>
        IF UserSetup.GET(USERID) THEN;
        IF PurchSlsPer.GET(UserSetup."Salespers./Purch. Code") THEN
         "Salesperson Code" := UserSetup."Salespers./Purch. Code"
        ELSE
        //28.01.2008 EDMS P3 <<
        "Salesperson Code" := Contact."Salesperson Code";
        StartWizard;
        */
    //end;


    //Unsupported feature: Code Modification on "CheckStatus(PROCEDURE 16)".

    //procedure CheckStatus();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Contact No." = '' THEN
          ERROR(Text009);
        IF "Interaction Template Code" = '' THEN
          ErrorMessage(FIELDCAPTION("Interaction Template Code"));
        IF "Salesperson Code" = '' THEN
          ErrorMessage(FIELDCAPTION("Salesperson Code"));
        IF Date = 0D THEN
        #8..23
           NOT TempAttachment."Attachment File".HASVALUE
        THEN
          ERROR(Text008);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4

              //TESTFIELD("Prospect Line No.");  // CNY.CRM

              IF"Salesperson Code" = '' THEN
        #5..26
        */
    //end;

    procedure CreateInteractionFromVehicle(var Vehicle: Record "25006005")
    var
        UserSetup: Record "91";
        PurchSlsPer: Record "13";
    begin
        //19.07.2013 EDMS P8

        DELETEALL;
        INIT;
        SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
        IF UserSetup.GET(USERID) THEN;
        IF PurchSlsPer.GET(UserSetup."Salespers./Purch. Code") THEN
         "Salesperson Code" := UserSetup."Salespers./Purch. Code";
        StartWizardVehicle;
    end;

    procedure StartWizardVehicle()
    var
        Opp: Record "5092";
    begin
        IF Campaign.GET("Campaign No.") THEN
          "Campaign Description" := Campaign.Description;
        IF Opp.GET("Opportunity No.") THEN
          "Opportunity Description" := Opp.Description;
        "Wizard Step" := "Wizard Step"::"1";
        "Interaction Successful" := TRUE;
        VALIDATE(Date,WORKDATE);
        INSERT;
        PAGE.RUNMODAL(PAGE::"Create Interaction",Rec,"Interaction Template Code");
    end;

    procedure ShowContactVehicles()
    var
        VehicleContactL: Record "25006013";
        ContactL: Record "5050";
        VehicleL: Record "25006005";
        SegmentSubLineL: Record "25006056";
        VehNoFilter: Text[1024];
    begin
        /*
        IF ContactL.GET("Contact No.") THEN BEGIN
          VehicleContactL.RESET;
          VehicleContactL.SETRANGE("Contact No.", "Contact No.");
          IF VehicleContactL.FINDFIRST THEN BEGIN
            REPEAT
              VehNoFilter += VehicleContactL."Vehicle Serial No." + '|';
            UNTIL VehicleContactL.NEXT = 0;
            VehNoFilter := COPYSTR(VehNoFilter, 1, STRLEN(VehNoFilter)-1);
            VehicleL.RESET;
            VehicleL.SETFILTER("Serial No.", VehNoFilter);
            PAGE.RUN(0, VehicleL);
          END;
        END;
         */
        SegmentSubLineL.RESET;
        SegmentSubLineL.SETRANGE("Segment No.", "Segment No.");
        SegmentSubLineL.SETRANGE("Line No.", "Line No.");
        PAGE.RUN(0, SegmentSubLineL);

    end;

    procedure VehicleRangeToSublines(VehiclePar: Record "25006005")
    var
        SegmentSubLineL: Record "25006056";
        NextLineNo: Integer;
    begin
        //it supposed that VehiclePar is filtered or temporary record
        IF VehiclePar.FINDFIRST THEN BEGIN
          SegmentSubLineL.RESET;
          SegmentSubLineL.SETRANGE("Segment No.", "Segment No.");
          SegmentSubLineL.SETRANGE("Line No.", "Line No.");
          IF SegmentSubLineL.FINDLAST THEN
            NextLineNo := SegmentSubLineL."SubLine No." + 10000
          ELSE
            NextLineNo := 10000;

          REPEAT
            VehicleAddToSublines(VehiclePar."Serial No.", NextLineNo);
            NextLineNo += 10000;
          UNTIL VehiclePar.NEXT = 0;
        END;
    end;

    procedure VehicleAddToSublines(VehSerNo: Code[20];NextLineNo: Integer)
    var
        SegmentSubLineL: Record "25006056";
    begin
        IF NextLineNo = 0 THEN BEGIN
          SegmentSubLineL.RESET;
          SegmentSubLineL.SETRANGE("Segment No.", "Segment No.");
          SegmentSubLineL.SETRANGE("Line No.", "Line No.");
          IF SegmentSubLineL.FINDLAST THEN
            NextLineNo := SegmentSubLineL."SubLine No." + 10000
          ELSE
            NextLineNo := 10000;
        END;
        SegmentSubLineL.INIT;
        SegmentSubLineL.VALIDATE("Segment No.", "Segment No.");
        SegmentSubLineL.VALIDATE("Line No.", "Line No.");
        SegmentSubLineL.VALIDATE("SubLine No.", NextLineNo);
        SegmentSubLineL.VALIDATE("Vehicle Serial No.", VehSerNo);
        SegmentSubLineL.INSERT(TRUE);
    end;

    procedure GetFirstVehicleNo(): Code[20]
    var
        SegmentSubLineL: Record "25006056";
    begin
        SegmentSubLineL.RESET;
        SegmentSubLineL.SETRANGE("Segment No.", "Segment No.");
        SegmentSubLineL.SETRANGE("Line No.", "Line No.");
        IF SegmentSubLineL.FINDFIRST THEN
          EXIT(SegmentSubLineL."Vehicle Serial No.")
        ELSE
          EXIT('');
    end;

    var
        SegmentSubLine: Record "25006056";

    var
        "-------------CNY.CRM----------": Integer;
        PipeLineMgmt_G: Record "33020141";
}

