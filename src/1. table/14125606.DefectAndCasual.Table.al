table 14125606 "Defect And Casual"
{

    fields
    {
        field(1; "Service Order No."; Code[20])
        {
            Description = 'SO';
        }
        field(2; "Code"; Code[20])
        {
            TableRelation = "PSF Master".Code WHERE("Is Code" = CONST(true));
        }
        field(3; "Sub Code"; Code[20])
        {
            Description = 'Not needed';
        }
        field(4; "Defect Code"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(DC));

            trigger OnValidate()
            var
                PSF: Record "PSF Master";
            begin
                PSF.RESET;
                PSF.SETRANGE("Sub Code", "Defect Code");
                IF PSF.FINDFIRST THEN
                    "Defect Value" := PSF.Description;
            end;
        }
        field(5; "Defect Value"; Text[50])
        {
        }
        field(6; "Casual Code 1"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 1" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 1", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 1" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(7; "Posted Service Order No."; Code[20])
        {
            Description = '//order is same only';
        }
        field(8; "Casual Code 2"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 2" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 2", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 2" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(9; "Casual Code 3"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 3" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 3", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 3" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(10; "Casual Code 4"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 4" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 4", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 4" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(11; "Casual Code 5"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 5" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 5", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 5" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(12; "Casual Code 6"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 6" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 6", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 6" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(13; "Casual Code 7"; Code[20])
        {
            TableRelation = "PSF Master"."Sub Code" WHERE(Code = FIELD(Code),
                                                           Type = CONST(CC));

            trigger OnValidate()
            begin
                IF "Casual Code 7" <> '' THEN
                    validateRepairRevist("Service Order No.", Code, Rec."Defect Code", "Casual Code 7", Rec)
                ELSE
                    revalidateAllOnClearing("Service Order No.", Code, "Defect Code", Rec);

                IF "Casual Code 7" = '' THEN BEGIN
                    "RV RR Code" := "RV RR Code"::" ";
                    servOrderClear("Service Order No.");
                END;
            end;
        }
        field(14; "Line No."; Integer)
        {
        }
        field(15; RVRR; Boolean)
        {
            Description = 'to check at once if condition matches';
        }
        field(16; "Customer Verbatim"; Text[100])
        {
        }
        field(50056; "RV RR Code"; Option)
        {
            Description = 'PSF';
            OptionCaption = ' ,Revisit,Repeat Repair';
            OptionMembers = " ",Revisit,"Repeat Repair";
        }
        field(50057; Posted; Boolean)
        {
        }
        field(50058; Type; Option)
        {
            OptionMembers = " ","Order",Invoice,"Line Order";
        }
        field(50059; VIN; Code[20])
        {
        }
        field(50060; "Action Taken"; Text[200])
        {
        }
        field(50061; "Is Revisit"; Boolean)
        {
        }
        field(50062; "Is Repair"; Boolean)
        {
        }
        field(70001; "Line Type"; Option)
        {
            Description = '//>>from here the history starts';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(70002; "No."; Code[20])
        {
            TableRelation = IF ("Line Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Line Type" = CONST(Item)) Item
            ELSE IF ("Line Type" = CONST(Labor)) Resource
            ELSE IF ("Line Type" = CONST("External Service")) "External Service"
            ELSE IF ("Line Type" = CONST(" ")) "Standard Text";
        }
        field(70003; Descrption; Text[100])
        {
        }
        field(70004; "Location Code"; Code[20])
        {
        }
        field(70005; Qunatity; Integer)
        {
        }
        field(70006; "Line Amt. Inc VAT"; Decimal)
        {
            Description = '//>>ends for history';
        }
        field(70007; "Past Invoice"; Boolean)
        {
        }
        field(70008; "Is Service Line"; Boolean)
        {
        }
        field(70009; "Is Complain"; Boolean)
        {
        }
        field(70010; "RV RR Justification"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "Service Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        blank: Boolean;

    local procedure findIfDayAndKMMatchesAndReturnPostedOrderNo(servOrderNo: Code[20]): Code[20]
    var
        PostedServiceInv: Record "Sales Invoice Header";
        ServSetup: Record "Service Mgt. Setup EDMS";
        ServHdr: Record "Service Header EDMS";
        dateFilter: Date;
        km: BigInteger;
        DocNo: Code[20];
        PostedServiceInv1: Record "Sales Invoice Header";
    begin
        ServSetup.GET;
        ServHdr.RESET;
        ServHdr.SETRANGE("No.", servOrderNo);
        ServHdr.FINDFIRST;
        PostedServiceInv.RESET;
        PostedServiceInv.SETRANGE("Vehicle Serial No.", ServHdr."Vehicle Serial No.");
        PostedServiceInv.SETRANGE("Model Version No.", ServHdr."Model Version No.");
        PostedServiceInv.SETRANGE("Document Profile", PostedServiceInv."Document Profile"::Service);
        IF PostedServiceInv.FINDSET THEN
            REPEAT
                IF dateFilter < PostedServiceInv."Posting Date" THEN
                    dateFilter := PostedServiceInv."Posting Date";
            UNTIL PostedServiceInv.NEXT = 0;

        PostedServiceInv1.RESET;
        PostedServiceInv1.SETRANGE("Vehicle Serial No.", ServHdr."Vehicle Serial No.");
        PostedServiceInv1.SETRANGE("Model Version No.", ServHdr."Model Version No.");
        PostedServiceInv1.SETRANGE("Document Profile", PostedServiceInv1."Document Profile"::Service);
        PostedServiceInv1.SETRANGE("Posting Date", dateFilter);
        IF PostedServiceInv1.FINDFIRST THEN BEGIN
            IF ((ServHdr."Arrival Date" - PostedServiceInv1."Posting Date") <= ServSetup."Revisit Repair Period") //THEN
              AND ((ServHdr.Kilometrage - PostedServiceInv1.Kilometrage) <= ServSetup."Revisit Repair KM") THEN
                EXIT(PostedServiceInv1."Service Order No.");
        END;
    end;

    local procedure getRevisitOrRepairInserted(servCode: Code[20]; SheetCode: Code[20]; DefCode: Code[20]; CCode: Code[20]; var previousCode: Code[20]): Boolean
    var
        OldDefect: Record "Defect And Casual";
    begin
        previousCode := findIfDayAndKMMatchesAndReturnPostedOrderNo(servCode);
        OldDefect.RESET;
        OldDefect.SETRANGE("Service Order No.", previousCode);
        OldDefect.SETRANGE(Code, SheetCode);
        OldDefect.SETRANGE("Defect Code", DefCode);
        IF OldDefect.FINDFIRST THEN BEGIN
            IF checkCCValidation(OldDefect."Casual Code 1", CCode) THEN //1
                EXIT(TRUE)
            ELSE
                IF checkCCValidation(OldDefect."Casual Code 2", CCode) THEN //2
                    EXIT(TRUE)
                ELSE
                    IF checkCCValidation(OldDefect."Casual Code 3", CCode) THEN //3
                        EXIT(TRUE)
                    ELSE
                        IF checkCCValidation(OldDefect."Casual Code 4", CCode) THEN //4
                            EXIT(TRUE)
                        ELSE
                            IF checkCCValidation(OldDefect."Casual Code 5", CCode) THEN //5
                                EXIT(TRUE)
                            ELSE
                                IF checkCCValidation(OldDefect."Casual Code 6", CCode) THEN //6
                                    EXIT(TRUE)
                                ELSE
                                    IF checkCCValidation(OldDefect."Casual Code 7", CCode) THEN //7
                                        EXIT(TRUE)
                                    ELSE
                                        EXIT(FALSE);
        END;

        blank := TRUE;
        //EXIT;
    end;

    local procedure checkCCValidation(P1: Code[20]; P2: Code[20]): Boolean
    begin
        IF P1 = P2 THEN
            EXIT(TRUE);
    end;

    local procedure validateRepairRevist(servCode: Code[20]; sheetCode: Code[20]; DefCode: Code[20]; CCode: Code[20]; DefRec: Record "Defect And Casual")
    var
        ServHdr: Record "Service Header EDMS";
        previousCode: Code[20];
    begin
        IF DefCode = '' THEN
            DefRec.DELETE;

        ServHdr.RESET;
        ServHdr.SETRANGE("No.", servCode);
        IF ServHdr.FINDFIRST THEN;

        /*IF ServHdr."RV RR Code" = ServHdr."RV RR Code"::Revisit THEN
          EXIT;
          */
        IF getRevisitOrRepairInserted(servCode, sheetCode, DefCode, CCode, previousCode) THEN BEGIN
            IF previousCode <> '' THEN BEGIN
                IF blank THEN
                    EXIT;
                "RV RR Code" := "RV RR Code"::"Repeat Repair";
                ServHdr."RV RR Code" := ServHdr."RV RR Code"::"Repeat Repair";
                ServHdr.MODIFY;
            END;
        END ELSE BEGIN
            IF previousCode <> '' THEN BEGIN
                IF blank THEN
                    EXIT;
                "RV RR Code" := "RV RR Code"::Revisit;
                ServHdr."RV RR Code" := ServHdr."RV RR Code"::Revisit;
                ServHdr.MODIFY;
            END;
        END;

    end;

    procedure getCurrentServiceLine(ServNo: Code[20])
    var
        ServLine: Record "Service Line EDMS";
        DefAndCas: Record "Defect And Casual";
        ServHdr: Record "Service Header EDMS";
        lineNo: Integer;
        DefAndCas1: Record "Defect And Casual";
    begin
        CLEAR(DefAndCas);
        ServHdr.RESET;
        ServHdr.SETRANGE("No.", ServNo);
        IF ServHdr.FINDFIRST THEN;


        DefAndCas1.RESET;
        DefAndCas1.SETRANGE("Service Order No.", ServNo);
        IF DefAndCas1.FINDLAST THEN
            lineNo := DefAndCas1."Line No."
        ELSE
            lineNo := 0;

        ServLine.RESET;
        ServLine.SETRANGE("Document No.", ServNo);
        IF ServLine.FINDSET THEN
            REPEAT

                lineNo += 10000;
                DefAndCas.RESET;
                DefAndCas.SETRANGE("Service Order No.", ServNo);
                DefAndCas.SETRANGE("Is Service Line", TRUE);
                DefAndCas.SETRANGE("No.", ServLine."No.");
                IF DefAndCas.FINDFIRST THEN BEGIN
                    DefAndCas.VIN := ServHdr.VIN;
                    DefAndCas."Line Type" := ServLine.Type;
                    DefAndCas."No." := ServLine."No.";
                    // DefAndCas."Line No." := lineNo;
                    DefAndCas.Descrption := ServLine.Description;
                    DefAndCas."Is Service Line" := TRUE;
                    DefAndCas.Qunatity := ServLine.Quantity;
                    DefAndCas."Location Code" := ServLine."Location Code";
                    DefAndCas."Line Amt. Inc VAT" := ServLine."Line Amount";
                    DefAndCas.MODIFY;
                END ELSE BEGIN
                    DefAndCas.INIT;
                    DefAndCas."Service Order No." := ServNo;
                    DefAndCas.VIN := ServHdr.VIN;
                    DefAndCas."Line Type" := ServLine.Type;
                    DefAndCas."No." := ServLine."No.";
                    DefAndCas.Descrption := ServLine.Description;
                    DefAndCas."Line No." := lineNo;
                    DefAndCas."Is Service Line" := TRUE;
                    DefAndCas.Qunatity := ServLine.Quantity;
                    DefAndCas."Location Code" := ServLine."Location Code";
                    DefAndCas."Line Amt. Inc VAT" := ServLine."Line Amount";
                    DefAndCas.Type := DefAndCas.Type::"Line Order";
                    DefAndCas.INSERT;
                END;
            UNTIL ServLine.NEXT = 0;
    end;

    local procedure revalidateAllOnClearing(servCode: Code[20]; sheetCode: Code[20]; DefCode: Code[20]; Def: Record "Defect And Casual")
    var
        DefTemp: Record "Standard Text" temporary;
    begin
        DefTemp.DELETEALL;
        insertFunc(Def."Casual Code 1", DefTemp);
        insertFunc(Def."Casual Code 2", DefTemp);
        insertFunc(Def."Casual Code 3", DefTemp);
        insertFunc(Def."Casual Code 4", DefTemp);
        insertFunc(Def."Casual Code 5", DefTemp);
        insertFunc(Def."Casual Code 6", DefTemp);
        insertFunc(Def."Casual Code 7", DefTemp);

        IF DefTemp.FINDSET THEN
            REPEAT
                validateRepairRevist(servCode, sheetCode, DefCode, DefTemp.Code, Def);
            UNTIL DefTemp.NEXT = 0;
    end;

    local procedure insertFunc("Code": Code[20]; DefTemp: Record "Standard Text" temporary)
    begin
        CLEAR(DefTemp);
        DefTemp.INIT;
        DefTemp.Code := Code;
        DefTemp.INSERT;
    end;

    local procedure servOrderClear(_Code: Code[20])
    var
        ServHdr: Record "Service Header EDMS";
    begin
        ServHdr.RESET;
        ServHdr.SETRANGE("No.", _Code);
        IF ServHdr.FINDFIRST THEN BEGIN
            ServHdr."RV RR Code" := ServHdr."RV RR Code"::" ";
            ServHdr.MODIFY;
        END;
        //ServHdr."Revisit Repair Reason" = ServHdr."RV RR Code"::
    end;
}

