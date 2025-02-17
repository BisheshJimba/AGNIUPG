table 25006136 "Service Package Version Line"
{
    // 19.02.2015 EDMS P21
    //   Modified Length from 30 to 50 for fields:
    //     70 Description
    //     80 "Description 2"
    // 
    // 18.03.2008. EDMS P2
    //   * Changed code CreateServLine

    Caption = 'Service Package Version Line';
    DrillDownPageID = 25006163;
    LookupPageID = 25006163;

    fields
    {
        field(2; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            NotBlank = true;
            TableRelation = "Service Package".No.;
        }
        field(4; "Version No."; Integer)
        {
            Caption = 'Version No.';
            NotBlank = true;
            TableRelation = "Service Package Version"."Version No." WHERE(Package No.=FIELD(Package No.));
        }
        field(6;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(8;"Package Type";Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Campaign Service Package,Service Package,Instruction';
            OptionMembers = "Campaign Service Package","Service Package",Instruction;
        }
        field(10;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;
        }
        field(50;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service";
        }
        field(60;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item WHERE (Item Type=CONST(Item))
                            ELSE IF (Type=CONST(Labor)) "Service Labor"
                            ELSE IF (Type=CONST(Ext. Service)) "External Service";

            trigger OnValidate()
            begin
                CASE Type OF
                 Type::" ":
                  BEGIN
                   StandardText.GET("No.");
                   Description := StandardText.Description;
                  END;
                 Type::"G/L Account":
                  BEGIN
                   GLAccount.GET("No.");
                   GLAccount.CheckGLAcc;
                   GLAccount.TESTFIELD("Direct Posting",TRUE);
                   Description := GLAccount.Name;
                   VALIDATE(Quantity,1);
                  END;
                 Type::Item:
                  BEGIN
                   Item.GET("No.");
                   Item.TESTFIELD("Item Type",Item."Item Type"::Item);
                   Description := Item.Description;
                   "Description 2" := Item."Description 2";
                   "Unit of Measure Code" := Item."Base Unit of Measure";
                  END;
                 Type::Labor:
                  BEGIN
                   Labor.GET("No.");
                   Description := Labor.Description;
                   "Description 2" := Labor."Description 2";
                   "Unit of Measure Code" := Labor."Unit of Measure Code";
                   IF NOT NotShowStandardTimeForm THEN
                     GetStandardTime;
                  END;
                 Type::"Ext. Service":
                  BEGIN
                   ExtService.GET("No.");
                   Description := ExtService.Description;
                   "Description 2" := ExtService."Description 2";
                   "Unit of Measure Code" := ExtService."Unit of Measure Code";
                   VALIDATE(Quantity,1);
                  END;
                END;

                IF Type <> Type::" " THEN BEGIN
                  VALIDATE("Unit of Measure Code");
                  UpdateUnitPrice(FIELDNO("No."));
                END;
            end;
        }
        field(70;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(80;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(90;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);

                IF (Type = Type::Item) AND (CurrFieldNo <> FIELDNO("No.")) THEN
                  UpdateUnitPrice(FIELDNO(Quantity))
                ELSE
                  VALIDATE("Discount %");
            end;
        }
        field(100;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(110;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                VALIDATE("Discount %");
            end;
        }
        field(111;"Discount %";Decimal)
        {
            BlankZero = true;
            Caption = 'Discount %';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(200;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(210;"Standard Time";Decimal)
        {
            Caption = 'Standard Time';

            trigger OnValidate()
            begin
                VALIDATE(Quantity,"Standard Time");
            end;
        }
        field(212;"Line Amount";Decimal)
        {
            Caption = 'Line Amount';
            Editable = false;
        }
        field(220;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                IF ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") AND
                   (NOT "Allow Invoice Disc.")
                THEN
                  UpdateAmounts;
            end;
        }
        field(230;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(240;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE(Quantity,"Quantity (Base)");
                UpdateUnitPrice(FIELDNO("Quantity (Base)"));
            end;
        }
        field(60100;Group;Boolean)
        {
            Caption = 'Group';
        }
        field(60110;"Group ID";Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Service Package Version Line"."Line No." WHERE (Package No.=FIELD(Package No.),
                                                                             Version No.=FIELD(Version No.),
                                                                             Group=CONST(Yes));

            trigger OnLookup()
            var
                VersionSpec: Record "25006136";
            begin
                IF Group THEN
                  EXIT;

                VersionSpec.RESET;
                VersionSpec.SETRANGE("Package No.", "Package No.");
                VersionSpec.SETRANGE("Version No.", "Version No.");

                IF LookUpMgt.LookUpServPackSpecGroup(VersionSpec,"Group ID") THEN
                 VALIDATE("Group ID");
                CALCFIELDS("Group Description");
            end;

            trigger OnValidate()
            begin
                CALCFIELDS("Group Description");
            end;
        }
        field(60120;"Group Description";Text[30])
        {
            CalcFormula = Lookup("Service Package Version Line".Description WHERE (Package No.=FIELD(Package No.),
                                                                                   Version No.=FIELD(Version No.),
                                                                                   Line No.=FIELD(Group ID)));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                VersionSpec: Record "25006136";
            begin
                IF Group THEN
                  EXIT;

                VersionSpec.RESET;
                VersionSpec.SETRANGE("Package No.", "Package No.");
                VersionSpec.SETRANGE("Version No.", "Version No.");

                IF LookUpMgt.LookUpServPackSpecGroup(VersionSpec,"Group ID") THEN
                 VALIDATE("Group ID");
                CALCFIELDS("Group Description");
            end;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006136,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version Line",FIELDNO("Variable Field 25006800"),
                  '',"Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006136,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version Line",FIELDNO("Variable Field 25006801"),
                  '',"Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006136,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version Line",FIELDNO("Variable Field 25006802"),
                  '',"Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(33020235;"Job Type";Code[20])
        {
            TableRelation = "Job Type Master".No. WHERE (Type=FILTER(Job));
        }
        field(33020236;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";
        }
    }

    keys
    {
        key(Key1;"Package No.","Version No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount",Quantity;
        }
        key(Key2;"Package Type","Make Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAccount: Record "15";
        StandardText: Record "7";
        Item: Record "27";
        Labor: Record "25006121";
        ExtService: Record "25006133";
        LookUpMgt: Codeunit "25006003";
        Currency: Record "4";
        SPVersion: Record "25006135";
        SPackage: Record "25006134";
        PriceCalcMgt: Codeunit "7000";
        VFMgt: Codeunit "25006004";
        NotShowStandardTimeForm: Boolean;
        VehicleServicePlanStageTmp_CS: Record "25006132" temporary;

    [Scope('Internal')]
    procedure CreateServLine(DocType: Option Quote,"Order","Return Order";DocNo: Code[20])
    var
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        LineNo: Integer;
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type",DocType);
        ServLine.SETRANGE("Document No.",DocNo);
        IF ServLine.FINDLAST THEN
          LineNo := ServLine."Line No."+10000;

        ServLine.INIT;
        ServLine."Line No." := LineNo;
        ServLine.VALIDATE("Document Type",DocType);
        ServLine.VALIDATE("Document No.",DocNo);
        ServLine.INSERT;

        ServLine.VALIDATE(Type,Type);

        //18.03.2008. EDMS P2 moved up this code>>
        ServLine."Package No." := "Package No.";
        ServLine."Package Version No." := "Version No.";
        ServLine."Package Version Spec. Line No." := "Line No.";
        //18.03.2008. EDMS P2 moved up this code<<

        ServLine.VALIDATE("No.","No.");
        //IF Type = Type::" " THEN
        ServLine.Description := Description;
        ServLine.VALIDATE("Unit of Measure","Unit of Measure Code");

        IF Type <> Type::" " THEN BEGIN
          IF Type = Type::"G/L Account" THEN BEGIN
            ServLine.VALIDATE("Line Discount %", "Discount %");  //21.02.2013 EDMS P8
            ServLine.VALIDATE("Unit Price", "Unit Price");  //01.02.2013 EDMS P8
          END;
          ServLine."Standard Time" := "Standard Time";
          ServLine.VALIDATE("Job Type","Job Type");
          ServLine.Description := Description;
          ServLine.VALIDATE(Quantity,Quantity);
          ServLine.VALIDATE("Unit Price","Unit Price");
        END;

        //29.01.2010 EDMS P2 >>
        IF ServicePackage.GET("Package No.") THEN
          ServLine."Campaign No." := ServicePackage."Campaign No.";
        //29.01.2010 EDMS P2 <<

        ServLine.Group := Group;
        ServLine."Group ID" := "Group ID";
        IF ServLine."Group ID" <> 0 THEN
         ServLine."Group ID" += LineNo;

        FillServiceVariableFields(ServLine, Rec);

        ServLine."Plan No." := VehicleServicePlanStageTmp_CS."Plan No.";
        ServLine."Plan Stage Recurrence" := VehicleServicePlanStageTmp_CS.Recurrence;
        ServLine."Plan Stage Code" := VehicleServicePlanStageTmp_CS.Code;

        ServLine.MODIFY;
    end;

    [Scope('Internal')]
    procedure GetStandardTime()
    var
        StandTime: Record "25006122";
    begin
        GetSPHeaders;

        StandTime.SETFILTER("Make Code","Make Code");
        IF NOT StandTime.FINDFIRST THEN
          StandTime.SETRANGE("Make Code",'');
        StandTime.SETRANGE("Labor No.","No.");
        IF  StandTime.ISEMPTY THEN
          EXIT;

        StandTime.SETFILTER("Prod. Year From",SPVersion."Prod. Year From");

        StandTime.SETFILTER("Prod. Year To",SPVersion."Prod. Year To");


        IF StandTime.COUNT <> 1 THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Service Labor Standard Times",StandTime) = ACTION::LookupOK THEN
          BEGIN
            VALIDATE("Standard Time",StandTime."Standard Time (Hours)");
            VALIDATE("Description 2",StandTime.Description);
          END
        END ELSE BEGIN
          IF StandTime.FINDFIRST THEN
          BEGIN
            VALIDATE("Standard Time",StandTime."Standard Time (Hours)");
            VALIDATE("Description 2",StandTime.Description);
          END
        END;
    end;

    [Scope('Internal')]
    procedure fReplaceStr(a: Text[250]): Text[1024]
    var
        b: Text[1024];
        c: Integer;
    begin
        a := CONVERTSTR(a,',;','||');

        c := STRPOS(a,'|');

        IF c = 0 THEN EXIT('*' + a + '*');

        REPEAT
         IF c <> 0 THEN
          BEGIN
           b := b + COPYSTR(a,1,c-1);
           a := COPYSTR(a,c+1);
          END
         ELSE
          BEGIN
           b := b + COPYSTR(a,1);
           a := '';
          END;

         b := b + '*';
         c := STRPOS(a,'|');

         IF (c <> 0) THEN
          b := b + '|*'
         ELSE
          BEGIN
           b := b + '|*' + a;
           a := '';
          END;
        UNTIL a = '';

        b := '*' + b + '*';

        EXIT(b);
    end;

    [Scope('Internal')]
    procedure UpdateAmounts()
    var
        LineDiscAmt: Decimal;
    begin
        TESTFIELD(Type);
        GetSPHeaders;

        LineDiscAmt :=
          ROUND(
            ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
            "Discount %" / 100,Currency."Amount Rounding Precision");

        IF "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - LineDiscAmt THEN
          "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - LineDiscAmt;
    end;

    local procedure GetSPHeaders()
    begin
        IF ("Version No." <> SPVersion."Version No.") OR ("Package No." <> SPVersion."Package No.") THEN
          SPVersion.GET("Package No.","Version No.");

        IF ("Package No." <> SPackage."No.") THEN BEGIN
          SPackage.GET("Package No.");
          "Customer Price Group" := SPackage."Customer Price Group";
          IF SPackage."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            SPackage.TESTFIELD("Currency Factor");
            Currency.GET(SPackage."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        GetSPHeaders;
        TESTFIELD("Qty. per Unit of Measure");

        CASE Type OF
          Type::Item,Type::Labor,Type::"Ext. Service":
            BEGIN
              PriceCalcMgt.FindDMSSPLineLineDisc(SPackage,Rec);
              PriceCalcMgt.FindDMSSPLinePrice(SPackage,Rec,CalledByFieldNo);
            END;
        END;
        VALIDATE("Unit Price");
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Package Version Line",intFieldNo));
    end;

    [Scope('Internal')]
    procedure SetNotShowTimeForm(NotShowForm1: Boolean)
    begin
        NotShowStandardTimeForm := NotShowForm1;
    end;

    [Scope('Internal')]
    procedure FillServiceVariableFields(var ServiceLine: Record "25006146";ServPackVerSpec: Record "25006136")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.OPEN(DATABASE::"Service Package Version Line");
        RecordRef.GETTABLE(ServPackVerSpec);
        RecordRef2.OPEN(DATABASE::"Service Line EDMS");
        RecordRef2.GETTABLE(ServiceLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Package Version Line");
        IF VariableFieldUsage.FINDFIRST THEN
          REPEAT
            VariableFieldUsage2.RESET;
            VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
            VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
            IF VariableFieldUsage2.FINDFIRST THEN BEGIN
              FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
              FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
              FieldRef2.VALUE(FieldRef.VALUE);
            END;
          UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(ServiceLine);
    end;

    [Scope('Internal')]
    procedure NoAssistEdit()
    var
        NonstockItem: Record "5718";
        NonstockItemMgt: Codeunit "5703";
    begin
        //EDMS
        IF Type = Type::Item THEN
         BEGIN
          NonstockItem.RESET;
          IF LookUpMgt.LookUpNonstockItem(NonstockItem,"No.") THEN
           BEGIN
            IF NonstockItem."Item No." = '' THEN
             BEGIN
              NonstockItemMgt.NonstockAutoItem(NonstockItem);
              NonstockItem.GET(NonstockItem."Entry No.");
              VALIDATE("No.", NonstockItem."Item No.");
             END
            ELSE
             BEGIN
              VALIDATE("No.", NonstockItem."Item No.");
             END;
           END;
         END;
    end;

    [Scope('Internal')]
    procedure SetCurrPlanStage(VehicleServicePlanStagePar: Record "25006132"): Integer
    begin
        CLEAR(VehicleServicePlanStageTmp_CS);
        VehicleServicePlanStageTmp_CS := VehicleServicePlanStagePar;
        EXIT(0);
    end;
}

