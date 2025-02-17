table 25006042 "Sales Splitting Line"
{
    Caption = 'Sales Line';
    DrillDownPageID = 516;
    LookupPageID = 516;
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = GetSourceTempDocNo THEN
                    ERROR(Text008);
                GetCust("Sell-to Customer No.");
                IF Cust."Bill-to Customer No." <> '' THEN
                    VALIDATE("Bill-to Customer No.", Cust."Bill-to Customer No.")
                ELSE BEGIN
                    IF "Bill-to Customer No." = "Sell-to Customer No." THEN
                        SkipBillToContact := TRUE;
                    VALIDATE("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := FALSE;
                END;
                UpdateLines(FIELDCAPTION("Sell-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header".No. WHERE(Document Type=FIELD(Document Type));
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"External Service";
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item),
                                     Line Type=CONST(Vehicle)) Item WHERE (Item Type=CONST(Model Version))
                                     ELSE IF (Type=CONST(Item),
                                              Line Type=FILTER(<>Vehicle)) Item WHERE (Item Type=FILTER(' '|Item))
                                              ELSE IF (Type=CONST(Resource)) Resource
                                              ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                              ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                              ELSE IF (Type=CONST(External Service)) "External Service";

            trigger OnValidate()
            var
                SalesSetup: Record "311";
                PrepaymentMgt: Codeunit "441";
            begin
            end;
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            var
                NewLocationCode: Code[20];
            begin
            end;
        }
        field(8;"Temp. Document No.";Integer)
        {

            trigger OnValidate()
            begin
                IF "Temp. Document No." = 0 THEN BEGIN
                //  SalesSplittingLine := Rec;

                  IF Line THEN BEGIN
                    IF "Document No." = '' THEN BEGIN
                      SalesSplittingLine.RESET;
                      IF SalesSplittingLine.FINDLAST THEN BEGIN
                        "Document No." := SalesSplittingLine."Document No.";
                        "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                      END;
                    END ELSE BEGIN
                      SalesSplittingLine.RESET;
                      //SalesSplittingLine.SETRANGE(Line, FALSE);
                      SalesSplittingLine.SETRANGE("Document Type", "Document Type");
                      SalesSplittingLine.SETRANGE("Document No.", "Document No.");
                      IF SalesSplittingLine.FINDLAST THEN
                        "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                    END;
                  END ELSE BEGIN
                    IF "Document No." = '' THEN BEGIN
                      SalesSplittingLine.RESET;
                      IF SalesSplittingLine.FINDLAST THEN BEGIN
                        "Document No." := SalesSplittingLine."Document No.";
                      END;
                    END;
                    SalesSplittingLine.RESET;
                    //SalesSplittingLine.SETRANGE(Line, FALSE);
                    SalesSplittingLine.SETRANGE("Document Type", "Document Type");
                    SalesSplittingLine.SETRANGE("Document No.", "Document No.");
                    IF SalesSplittingLine.FINDLAST THEN
                      "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                    "Temp. Document No." += 10000;
                  END;
                  IF "Temp. Document No." = 0 THEN
                    "Temp. Document No." := 10000;
                END;
            end;
        }
        field(9;"Temp. Line No.";Integer)
        {

            trigger OnValidate()
            begin
                IF "Temp. Line No." = 0 THEN BEGIN
                  SalesSplittingLine.RESET;
                  SalesSplittingLine.SETRANGE("Document Type", "Document Type");
                  SalesSplittingLine.SETRANGE("Document No.", "Document No.");
                  SalesSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
                  IF SalesSplittingLine.FINDLAST THEN
                    "Temp. Line No." := SalesSplittingLine."Temp. Line No.";
                  "Temp. Line No." += 10000;
                END;
            end;
        }
        field(10;Line;Boolean)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "99000815";
            begin
            end;
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(12;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
            end;
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF "Temp. Document No." = GetSourceTempDocNo THEN
                  ERROR(Text008);
                GetCust("Bill-to Customer No.");
                "Currency Code" := Cust."Currency Code";
                UpdateLines(FIELDCAPTION("Bill-to Customer No."),CurrFieldNo <> 0);
            end;
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(7160;"Quantity Share %";Decimal)
        {
            Caption = 'Quantity Share %';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Line Type" = "Line Type"::Vehicle THEN
                  IF NOT (("Quantity Share %" = 0) OR ("Quantity Share %" = 100)) THEN
                    ERROR(Text105, TABLECAPTION, FORMAT("Document Type")+', '+FORMAT("Document No.")+', '+FORMAT("Temp. Document No.")+', '+FORMAT(Line)+', '+FORMAT("Temp. Line No."),
                     FIELDCAPTION("Quantity Share %"));
                "New Quantity" := ROUND(Quantity*"Quantity Share %"/100, 0.00001);
                DecimalTemp := ROUND(Quantity*"Quantity Share %"/100, 0.00001);
                IF "Quantity Share %" > 0 THEN BEGIN
                  "Amount Share %" := 0;
                  "New Amount" := 0;
                END;
                UpdateLines(FIELDCAPTION("Quantity Share %"),CurrFieldNo <> 0);
            end;
        }
        field(7170;"New Quantity";Decimal)
        {
            Caption = 'New Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Quantity > 0 THEN
                  VALIDATE("Quantity Share %", ROUND(100*"New Quantity"/Quantity, 0.00001))
                ELSE
                  VALIDATE("Quantity Share %", 0);
            end;
        }
        field(7180;"Amount Share %";Decimal)
        {
            Caption = 'Amount Share';
            MinValue = 0;

            trigger OnValidate()
            begin
                //logic taken from Sales Line:
                GetHeader;
                "New Amount" := ROUND(Amount*"Amount Share %"/100, Currency."Amount Rounding Precision");
                IF "Amount Share %" > 0 THEN BEGIN
                  "Quantity Share %" := 0;
                  "New Quantity" := 0;
                END;
                UpdateLines(FIELDCAPTION("Amount Share %"),CurrFieldNo <> 0);
            end;
        }
        field(7190;"New Amount";Decimal)
        {
            Caption = 'New Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                IF Amount > 0 THEN BEGIN
                  GetHeader;
                  VALIDATE("Amount Share %", ROUND(100*"New Amount"/Amount, Currency."Amount Rounding Precision"));
                END ELSE
                  VALIDATE("Amount Share %", 0);
            end;
        }
        field(7200;"New Document No.";Code[20])
        {
            Caption = 'New Document No.';
            Description = 'supposed to be filled only at processing';
        }
        field(7210;Include;Boolean)
        {
            Caption = 'Include';

            trigger OnValidate()
            begin
                IF Include THEN BEGIN
                  VALIDATE("New Quantity", Quantity);
                  ChangeIncludeInfo(0);
                END ELSE BEGIN
                  VALIDATE("New Quantity", 0);
                  ChangeIncludeInfo(Quantity);
                END;
            end;
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";

            trigger OnValidate()
            var
                cuDocMgtDMS: Codeunit "25006000";
            begin
            end;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Temp. Document No.",Line,"Temp. Line No.")
        {
            Clustered = true;
        }
        key(Key2;Line,"Document Type","Document No.","Temp. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "99000886";
        ItemJnlLine: Record "83";
        JobCreateInvoice: Codeunit "1002";
        DealApplEntry: Record "25006053";
        SalesCommentLine: Record "44";
        DealApplType: Record "25006055";
    begin
        IF NOT Line THEN BEGIN
          SalesSplittingLine.RESET;
          SalesSplittingLine.SETRANGE(Line, TRUE);
          SalesSplittingLine.SETRANGE("Document Type", "Document Type");
          SalesSplittingLine.SETRANGE("Document No.", "Document No.");
          SalesSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
          SalesSplittingLine.DELETEALL;
        END;
    end;

    trigger OnInsert()
    var
        SalesHeader2: Record "36";
    begin
        VALIDATE("Temp. Document No.");
        VALIDATE("Temp. Line No.");
    end;

    trigger OnModify()
    var
        DealApplEntry: Record "25006053";
        DealApplType: Record "25006055";
    begin
    end;

    var
        SalesSplittingLine: Record "25006042";
        SalesSplittingHeader: Record "25006042";
        Currency: Record "4";
        GLSetup: Record "98";
        DecimalTemp: Decimal;
        SalesHeader: Record "36";
        Cust: Record "18";
        SkipBillToContact: Boolean;
        Text0001: Label 'Would you like to copy that value to lines?';
        Text0002: Label 'There is problem no initialise %1.';
        Text0003: Label 'There is nothing to process.';
        Text0004: Label 'Is not possible to find %1 record with %2.';
        Text007: Label 'Exist Service Labor Allocation entry, which is not finished.';
        Text008: Label 'The field in that record is not allowed modify.';
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text103: Label 'Would you like to delete created split prepare lines?';
        Text104: Label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';
        Text105: Label '%1 with %2 value for field %3 could be only 0 or 100.';

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        PricesIncVar: Integer;
        SalesHeaderLoc: Record "36";
    begin
        IF NOT SalesHeaderLoc.GET("Document Type","Document No.") THEN BEGIN
          SalesHeaderLoc."No." := '';
          SalesHeaderLoc.INIT;
        END;
        IF SalesHeaderLoc."Prices Including VAT" THEN
          PricesIncVar := 1
        ELSE
          PricesIncVar := 0;
        CLEAR(SalesHeaderLoc);
        EXIT('2,'+FORMAT(PricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Sales Splitting Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    [Scope('Internal')]
    procedure ApplyInsertAsWholeDoc()
    var
        SalesSplittingLineL: Record "25006042";
        TempDocNo: Integer;
    begin
        SalesSplittingLineL.RESET;
        SalesSplittingLineL.SETRANGE("Document Type", "Document Type");
        SalesSplittingLineL.SETRANGE("Document No.", "Document No.");
        SalesSplittingLineL.SETRANGE("Temp. Document No.", "Temp. Document No.");
        IF SalesSplittingLineL.FINDFIRST THEN BEGIN
          VALIDATE("Temp. Document No.", 0);
          TempDocNo := "Temp. Document No.";
          REPEAT
            INIT;
            TRANSFERFIELDS(SalesSplittingLineL);
            "Temp. Document No." := TempDocNo;
            VALIDATE("Temp. Line No.", 0);
            INSERT;
          UNTIL SalesSplittingLineL.NEXT = 0;
          SalesSplittingLineL.SETRANGE("Temp. Document No.", TempDocNo);
          SalesSplittingLineL.SETRANGE(Line, FALSE);
          IF SalesSplittingLineL.FINDFIRST THEN BEGIN
            SalesSplittingLineL.VALIDATE("Quantity Share %", 0);
            SalesSplittingLineL.VALIDATE("Amount Share %", 0);
            SalesSplittingLineL.MODIFY;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ApplyInsertAsHeaderByDoc(DocType: Integer;DocNo: Code[20])
    var
        SalesHeaderL: Record "36";
        SalesLineL: Record "37";
        SalesSplittingLineL: Record "25006042";
        TempDocNo: Integer;
        TempLineNo: Integer;
    begin
        IF SalesHeaderL.GET(DocType, DocNo) THEN BEGIN
          SalesLineL.RESET;
          SalesLineL.SETRANGE("Document Type", SalesHeaderL."Document Type");
          SalesLineL.SETRANGE("Document No.", SalesHeaderL."No.");
          IF SalesLineL.FINDFIRST THEN BEGIN
            SalesSplittingLineL.INIT;
            CopyFldsSalesH2SplitLine(SalesHeaderL, SalesSplittingLineL);
            SalesSplittingLineL.VALIDATE(Line, FALSE);
            SalesSplittingLineL.VALIDATE("Line No.", 0);
            SalesSplittingLineL.VALIDATE("Document Type", DocType);
            SalesSplittingLineL.VALIDATE("Document No.", DocNo);
            SalesSplittingLineL.VALIDATE("Temp. Document No.", 0);
            SalesSplittingLineL."Temp. Line No." := 0;
            SalesSplittingLineL.INSERT(TRUE);
            TempDocNo := SalesSplittingLineL."Temp. Document No.";
            REPEAT
              SalesSplittingLineL.INIT;
              CopyFldsSalesL2SplitLine(SalesLineL, SalesSplittingLineL);
              SalesSplittingLineL."Temp. Document No." := TempDocNo;
              SalesSplittingLineL."Temp. Line No." := 0;
              SalesSplittingLineL.Line := TRUE;
              IF SalesSplittingLineL."Temp. Document No." = 10000 THEN
                SalesSplittingLineL.Include := TRUE;
              SalesSplittingLineL.INSERT(TRUE);
            UNTIL SalesLineL.NEXT = 0;
            GET(SalesSplittingLineL."Document Type", SalesSplittingLineL."Document No.", SalesSplittingLineL."Temp. Document No.",
              TRUE, SalesSplittingLineL."Temp. Line No.");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ProceedDocSplit()
    var
        SalesHeaderL: Record "36";
        SalesHeaderL2: Record "36";
        SalesLineL: Record "37";
        SalesLineL2: Record "37";
        SalesLineDest: Record "37";
        SalesLineSourceTmp: Record "37" temporary;
        FirstTempDocumentNo: Integer;
        PreviousTempDocumentNo: Integer;
        MessageText: Text[250];
        Text101: Label 'There are created additional documents with %1: %2';
        DocNoFilterString: Text[100];
        DocNoFilterString2: Text[100];
        SourceDocHours: Decimal;
        SplittingHeaderRecNo: Integer;
        SalesSplittingLineSource: Record "25006042";
        SalesSplittingLineDest: Record "25006042";
        ShareToAdjustQtySrc: Decimal;
        ShareToAdjustQtyDest: Decimal;
        ShareOfLineInAlloc: Decimal;
        NewDocNo: Code[20];
        NewLineNo: Integer;
        NewLineQtyShare: Decimal;
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        LoopCurrCnt: Integer;
        SeparateFunctPars: Text[30];
    begin
        //at first do compare values

        //prepare source Sales line
        SalesLineL.RESET;
        SalesLineL.SETRANGE("Document Type", "Document Type");
        SalesLineL.SETRANGE("Document No.", "Document No.");
        SalesLineSourceTmp.RESET;
        SalesLineSourceTmp.DELETEALL;
        IF SalesLineL.FINDFIRST THEN
        REPEAT
          SalesLineSourceTmp := SalesLineL;
          SalesLineSourceTmp.INSERT;
        UNTIL SalesLineL.NEXT = 0;

        IF NOT SalesHeaderL.GET("Document Type", "Document No.") THEN
          ERROR(Text0002, SalesHeaderL.TABLECAPTION);

        SalesSplittingHeader.RESET;
        SalesSplittingHeader.SETRANGE(Line, FALSE);
        SalesSplittingHeader.SETRANGE("Document Type", "Document Type");
        SalesSplittingHeader.SETRANGE("Document No.", "Document No.");

        // that part creates all "Sales Header EDMS" + "Sales Line EDMS"
        // and put correcr quantities
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE(Line, TRUE);
        SalesSplittingLine.SETRANGE("Document Type", "Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        IF NOT SalesSplittingLine.FINDFIRST THEN
          ERROR(Text0003);
        FirstTempDocumentNo := SalesSplittingLine."Temp. Document No.";
        PreviousTempDocumentNo := FirstTempDocumentNo;
        DocNoFilterString := ''''+SalesSplittingLine."Document No."+'''';
        DocNoFilterString2 := ''; // it stores the same filter but only without original document
        REPEAT
          IF FirstTempDocumentNo = SalesSplittingLine."Temp. Document No." THEN BEGIN
            // just modify values of lines - for original document
            IF NOT SalesLineL.GET(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                SalesSplittingLine."Line No.") THEN
              ERROR(Text0004, SalesLineL.TABLECAPTION, FORMAT(SalesSplittingLine."Document Type") + ', ' +
                SalesSplittingLine."Document No." + ', ' + FORMAT(SalesSplittingLine."Line No."));
            SalesLineL.VALIDATE(Quantity, SalesSplittingLine."New Quantity");
            SalesLineL.MODIFY;
             // modify allocation
          END ELSE BEGIN
            IF PreviousTempDocumentNo <> SalesSplittingLine."Temp. Document No." THEN BEGIN
              // NEED CREATE HEADER RECORD AT FIRST
              SalesHeaderL2.INIT;
              SalesHeaderL2.VALIDATE("Document Type", SalesHeader."Document Type");
              SalesHeaderL2.VALIDATE("No.", '');
              SalesHeaderL2.INSERT(TRUE);
              SalesSplittingHeader.SETRANGE("Temp. Document No.", SalesSplittingLine."Temp. Document No.");
              SalesSplittingHeader.FINDFIRST;
              SalesSplittingHeader."New Document No." := SalesHeaderL2."No.";
              SalesSplittingHeader.MODIFY;

              SalesHeaderL2.TRANSFERFIELDS(SalesHeaderL,FALSE);
              IF SalesHeaderL."Posting No." <> '' THEN
                SalesHeaderL2.VALIDATE("Posting No.", SalesHeaderL2."No.");

              SalesHeaderL2."No." := SalesSplittingHeader."New Document No.";
              IF SalesHeaderL."Sell-to Customer No." <> SalesSplittingHeader."Sell-to Customer No." THEN BEGIN
                SalesHeaderL2."Sell-to Customer No." := '';
                SalesHeaderL2."Bill-to Customer No." := '';
                SalesHeaderL2.VALIDATE("Sell-to Customer No.", SalesSplittingHeader."Sell-to Customer No.");
              END;
              IF SalesHeaderL2."Bill-to Customer No." <> SalesSplittingHeader."Bill-to Customer No." THEN BEGIN
                SalesHeaderL2."Bill-to Customer No." := '';
                SalesHeaderL2.VALIDATE("Bill-to Customer No.", SalesSplittingHeader."Bill-to Customer No.");
              END;
              IF SalesHeaderL."Currency Code" <> SalesSplittingHeader."Currency Code" THEN BEGIN
                SalesHeaderL2."Currency Code" := '';
                SalesHeaderL2.VALIDATE("Currency Code", SalesSplittingHeader."Currency Code");
              END;
              SalesHeaderL2.MODIFY(TRUE);
              PreviousTempDocumentNo := SalesSplittingLine."Temp. Document No.";
              IF MessageText <> '' THEN
                MessageText += ', ';
              MessageText += FORMAT(SalesHeaderL2."No.");
              DocNoFilterString += '|'''+ SalesHeaderL2."No." +'''';
              IF DocNoFilterString2 <> '' THEN
                DocNoFilterString2 += '|';
              DocNoFilterString2 += ''''+ SalesHeaderL2."No." +'''';
            END;
            // create lines
            IF NOT SalesLineL.GET(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                SalesSplittingLine."Line No.") THEN
              ERROR(Text0004, SalesLineL.TABLECAPTION, FORMAT(SalesSplittingLine."Document Type") + ', ' +
                SalesSplittingLine."Document No." + ', ' + FORMAT(SalesSplittingLine."Line No."));
            IF //(SalesSplittingLine.Type = 0) OR
                //(SalesSplittingLine."New Quantity" <> 0)
              SalesSplittingLine.Include
            THEN BEGIN
              SalesLineL2.INIT;
              SalesLineL2.TRANSFERFIELDS(SalesLineL, FALSE);
              SalesLineL2."Document Type" := SalesSplittingHeader."Document Type";
              SalesLineL2."Document No." := SalesSplittingHeader."New Document No.";
              SalesLineL2."Line No." := SalesSplittingLine."Line No.";
              SalesLineL2."Sell-to Customer No." := SalesSplittingHeader."Sell-to Customer No.";
              SalesLineL2."Bill-to Customer No." := SalesSplittingHeader."Bill-to Customer No.";
              SalesLineL2."Currency Code" := SalesSplittingHeader."Currency Code";
              //SalesLineL2.VALIDATE("No.", SalesLineL."No.");
              //SalesLineL2.VALIDATE("Location Code", SalesSplittingLine."Location Code");
              SalesLineL2.VALIDATE(Quantity, SalesSplittingLine."New Quantity");
              //SalesLine2.VALIDATE("Unit Price", SalesSplittingLine."Unit Price");
              SalesLineL2.Description := SalesSplittingLine.Description;
              SalesLineL2.INSERT(TRUE);
              // set doc link to new created
              SalesSplittingLine."New Document No." := SalesSplittingHeader."New Document No.";
              SalesSplittingLine.MODIFY;
            END;
          END;
        UNTIL SalesSplittingLine.NEXT = 0;
        SalesSplittingHeader.SETRANGE("Temp. Document No.");
        // adjust reservations
        IF SalesSplittingLine.FINDFIRST THEN BEGIN
          SalesLineL.RESET;
          SalesLineL.SETRANGE("Document Type", SalesSplittingLine."Document Type");
          SalesLineL.SETFILTER("Document No.", DocNoFilterString);
          SalesLineL.SETRANGE(Type, SalesSplittingLine.Type::Item);
          IF SalesLineL.FINDFIRST THEN BEGIN
            REPEAT
              IF SalesLineL."Document No." <> SalesSplittingLine."Document No." THEN
              // do not proceed line of original document
                IF SalesLineL.Reserve <> SalesLineL.Reserve::Never THEN  //02.07.2013 EDMS P8
                  SalesLineL.AutoReserve;
            UNTIL SalesLineL.NEXT = 0;
          END;
        END;

        // delete lines with 0 Quantity in original Doc.
        SalesLineL.RESET;
        SalesLineL.SETRANGE("Document Type", SalesSplittingLine."Document Type");
        SalesLineL.SETFILTER("Document No.", "Document No.");
        SalesLineL.SETFILTER(Type,'<>0');
        SalesLineL.SETRANGE(Quantity,0);
        IF SalesLineL.FINDFIRST THEN
          REPEAT
            SalesLineL.DELETE(TRUE);
          UNTIL SalesLineL.NEXT = 0;

        MESSAGE(Text101, SalesHeaderL2.FIELDCAPTION("No."), MessageText);
        DeleteDocSplit;
    end;

    [Scope('Internal')]
    procedure DeleteDocSplit()
    var
        ServiceHeader: Record "25006145";
        ServiceHeader2: Record "25006145";
        ServiceLine: Record "25006146";
        ServiceLine2: Record "25006146";
        FirstTempDocumentNo: Integer;
        LastTempDocumentNo: Integer;
    begin
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE(Line, FALSE);
        SalesSplittingLine.SETRANGE("Document Type", "Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        SalesSplittingLine.DELETEALL(TRUE);
    end;

    local procedure GetHeader()
    begin
        TESTFIELD("Document No.");
        IF SalesSplittingHeader.Line OR ("Document Type" <> SalesSplittingHeader."Document Type") OR
            ("Temp. Document No." <> SalesSplittingHeader."Temp. Document No.") THEN BEGIN
          SalesSplittingHeader.SETRANGE(Line, FALSE);
          SalesSplittingHeader.SETRANGE("Document Type", "Document Type");
          SalesSplittingHeader.SETRANGE("Temp. Document No.", "Temp. Document No.");
          IF SalesSplittingHeader.FINDFIRST THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            IF SalesSplittingHeader."Currency Code" = '' THEN
              Currency.InitRoundingPrecision
            ELSE BEGIN
              //SalesSplittingHeader.TESTFIELD("Currency Factor");
              Currency.GET(SalesSplittingHeader."Currency Code");
              Currency.TESTFIELD("Amount Rounding Precision");
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure GetSourceTempDocNo(): Integer
    var
        ServiceSplittingLine: Record "25006128";
    begin
        SalesSplittingLine.SETRANGE("Document Type", "Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        SalesSplittingLine.SETRANGE(Line, FALSE);
        SalesSplittingLine.FINDFIRST;
        EXIT(SalesSplittingLine."Temp. Document No.");
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        IF NOT (("Document Type" = "Document Type"::Quote) AND (CustNo = '')) THEN BEGIN
          IF CustNo <> Cust."No." THEN
            Cust.GET(CustNo);
        END ELSE
          CLEAR(Cust);
    end;

    [Scope('Internal')]
    procedure UpdateLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        ChangeLogMgt: Codeunit "423";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
        IF Line THEN EXIT;
        IF NOT (ChangedFieldName IN
          [FIELDCAPTION("Sell-to Customer No."),
          FIELDCAPTION("Location Code"),
          FIELDCAPTION("Bill-to Customer No."),
          FIELDCAPTION("Currency Code"),
          FIELDCAPTION("Quantity Share %")]) THEN
            EXIT;

        IF AskQuestion THEN BEGIN
          Question := STRSUBSTNO(
              Text031 +
              Text032,ChangedFieldName);
          IF GUIALLOWED THEN
            IF NOT DIALOG.CONFIRM(Question,TRUE) THEN
              EXIT;
        END;

        SalesSplittingLine.LOCKTABLE;
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE(Line, TRUE);
        SalesSplittingLine.SETRANGE("Document Type","Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        SalesSplittingLine.SETRANGE("Temp. Document No.", "Temp. Document No.");
        IF SalesSplittingLine.FINDSET THEN
          REPEAT
            CASE ChangedFieldName OF
              FIELDCAPTION("Sell-to Customer No."):
                SalesSplittingLine.VALIDATE("Sell-to Customer No.", "Sell-to Customer No.");
              FIELDCAPTION("Location Code"):
                SalesSplittingLine.VALIDATE("Location Code", "Location Code");
              FIELDCAPTION("Bill-to Customer No."):
                SalesSplittingLine.VALIDATE("Bill-to Customer No.", "Bill-to Customer No.");
              FIELDCAPTION("Currency Code"):
                SalesSplittingLine.VALIDATE("Currency Code", "Currency Code");
              FIELDCAPTION("Quantity Share %"):
                SalesSplittingLine.VALIDATE("Quantity Share %", "Quantity Share %");
            END;
            SalesSplittingLine.MODIFY(TRUE);
          UNTIL SalesSplittingLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateSplitingForDoc(var SalesHeaderPar: Record "36")
    begin
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE(Line, FALSE);
        SalesSplittingLine.SETRANGE("Document Type", SalesHeaderPar."Document Type");
        SalesSplittingLine.SETRANGE("Document No.", SalesHeaderPar."No.");
        IF NOT SalesSplittingLine.FINDFIRST THEN
          ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type", SalesHeaderPar."No.");
        IF SalesSplittingLine.COUNT < 2 THEN BEGIN
          ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type", SalesHeaderPar."No.");
          DocsShareMakeFirstFull;
        END;
        IF SalesSplittingLine.FINDFIRST THEN BEGIN
          GET(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
            SalesSplittingLine."Temp. Document No.", SalesSplittingLine.Line, SalesSplittingLine."Temp. Line No.");
        END;
    end;

    [Scope('Internal')]
    procedure CreateSpliting()
    var
        ServiceHeader: Record "25006145";
    begin
        EVALUATE("Document Type", GETFILTER("Document Type"));
        "Document No." := GETFILTER("Document No.");
        SalesHeader.GET("Document Type", "Document No.");
        CreateSplitingForDoc(SalesHeader);
    end;

    [Scope('Internal')]
    procedure DocsShareMakeEqual()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        WITH SalesSplittingLine DO BEGIN
          IF FINDFIRST THEN BEGIN
            RecCount := COUNT;
            TotalUsedPercent := 0;
            REPEAT
              VALIDATE("Quantity Share %", ROUND(100/RecCount, 0.01));
              MODIFY;
              TotalUsedPercent += "Quantity Share %";
            UNTIL NEXT = 0;
            IF TotalUsedPercent <> 100 THEN BEGIN
              FINDLAST;
              VALIDATE("Quantity Share %", "Quantity Share %" + (100 - TotalUsedPercent));
              MODIFY;
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure DocsShareMakeFirstFull()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        WITH SalesSplittingLine DO BEGIN
          IF FINDFIRST THEN BEGIN
            RecCount := COUNT;
            VALIDATE("Quantity Share %", 100);
            MODIFY;
            IF NEXT <> 0 THEN
              REPEAT
                VALIDATE("Quantity Share %", 0);
                MODIFY;
              UNTIL NEXT = 0;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure OpenFormForDoc(var SalesHeaderPar: Record "36")
    var
        FormRunResult: Action;
    begin
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", SalesHeaderPar."Document Type");
        SETRANGE("Document No.", SalesHeaderPar."No.");
        PAGE.RUN(PAGE::"Sales Splitting", Rec);
        //FormRunResult := PAGE.RUNMODAL(PAGE::"Sales Splitting", Rec);
        //SETRANGE(Line, FALSE);
        //SETRANGE("Document Type", SalesHeaderPar."Document Type");
        //SETRANGE("Document No.", SalesHeaderPar."No.");

        //IF FINDFIRST THEN
          //IF FormRunResult IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            //ProceedDocSplit;
        //  END ELSE
          //  IF CONFIRM(Text103, TRUE) THEN BEGIN
            //  DeleteDocSplit;
            //END;
    end;

    [Scope('Internal')]
    procedure CheckDocTotalAmount(var SourceDocAmount: Decimal;var DestDocAmount: Decimal) AmountDiff: Decimal
    var
        SalesHeaderTmp: Record "36" temporary;
        SalesLineTmp: Record "37" temporary;
        SalesLineL: Record "37";
        CurrLineNo: Integer;
        LinesCount: Integer;
    begin
        SourceDocAmount := 0;
        IF SalesHeader.GET("Document Type", "Document No.") THEN BEGIN
          SalesHeader.CALCFIELDS(Amount);
          IF SalesHeader."Currency Factor" = 0 THEN
            SalesHeader."Currency Factor" := 1;
        //  SourceDocAmount := ROUND(SalesHeader.Amount/SalesHeader."Currency Factor");
          WITH SalesLineL DO BEGIN
            RESET;
            SETRANGE("Document Type", SalesHeader."Document Type");
            SETRANGE("Document No.", SalesHeader."No.");
            IF FINDFIRST THEN
              REPEAT
                SourceDocAmount += ROUND(SalesLineL."Line Amount"/SalesHeader."Currency Factor");
              UNTIL NEXT = 0;
          END;

          WITH SalesHeaderTmp DO BEGIN
            RESET;
            DELETEALL;
            SalesHeaderTmp := SalesHeader;
            INSERT;
          END;
          WITH SalesLineTmp DO BEGIN
            RESET;
            DELETEALL;
          END;

          SalesSplittingHeader.RESET;
          SalesSplittingHeader.SETRANGE(Line, FALSE);
          SalesSplittingHeader.SETRANGE("Document Type", "Document Type");
          SalesSplittingHeader.SETRANGE("Document No.", "Document No.");
          SalesSplittingLine.RESET;
          SalesSplittingLine.SETRANGE(Line, TRUE);
          SalesSplittingLine.SETRANGE("Document Type", "Document Type");
          SalesSplittingLine.SETRANGE("Document No.", "Document No.");
          IF NOT SalesSplittingLine.FINDFIRST THEN
            ERROR(Text0003);
          LinesCount := SalesSplittingLine.COUNT;
          DestDocAmount := 0;
          CurrLineNo := 0;
          REPEAT
            IF NOT SalesLineL.GET(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                  SalesSplittingLine."Line No.") THEN
                ERROR(Text0004, SalesLineL.TABLECAPTION, FORMAT(SalesSplittingLine."Document Type") + ', ' +
                  SalesSplittingLine."Document No." + ', ' + FORMAT(SalesSplittingLine."Line No."));

            SalesSplittingHeader.SETRANGE("Temp. Document No.", SalesSplittingLine."Temp. Document No.");
            SalesSplittingHeader.FINDFIRST;

            SalesLineTmp.INIT;
            SalesLineTmp.TRANSFERFIELDS(SalesLineL, FALSE);
            SalesLineTmp."Document Type" := SalesSplittingHeader."Document Type";
            SalesLineTmp."Document No." := SalesSplittingHeader."Document No.";
            CurrLineNo += 10000;
            SalesLineTmp."Line No." := CurrLineNo;
            SalesLineTmp."Sell-to Customer No." := SalesSplittingHeader."Sell-to Customer No.";
            SalesLineTmp."Bill-to Customer No." := SalesSplittingHeader."Bill-to Customer No.";
            SalesLineTmp."Currency Code" := SalesSplittingHeader."Currency Code";
            //SalesLineTmp.VALIDATE("No.", SalesSplittingLine."No.");
            //SalesLineTmp.VALIDATE("Location Code", SalesSplittingLine."Location Code");
            SalesLineTmp.VALIDATE(Quantity, SalesSplittingLine."New Quantity");
            SalesLineTmp.INSERT(TRUE);
        //    SalesLineTmp.MODIFY(TRUE);

            SalesHeaderTmp.VALIDATE("Currency Code", SalesSplittingHeader."Currency Code");
            IF SalesHeaderTmp."Currency Factor" = 0 THEN
              SalesHeaderTmp."Currency Factor" := 1;

            DestDocAmount += ROUND(SalesLineTmp."Line Amount"/SalesHeaderTmp."Currency Factor");
          UNTIL SalesSplittingLine.NEXT = 0;
          AmountDiff := SourceDocAmount - DestDocAmount;
        END ELSE
          ERROR(Text0004, SalesHeader.TABLECAPTION, FORMAT("Document Type") + ', ' + "Document No.");
        EXIT(AmountDiff);
    end;

    [Scope('Internal')]
    procedure CopyFldsSalesL2SplitLine(SalesLinePar: Record "37";var SalesSplittingLinePar: Record "25006042"): Integer
    begin
        WITH SalesLinePar DO BEGIN
          SalesSplittingLinePar."Document Type" := "Document Type";
          SalesSplittingLinePar."Document No." := "Document No.";
          SalesSplittingLinePar."Sell-to Customer No." := "Sell-to Customer No.";
          SalesSplittingLinePar."Line No." := "Line No.";
          SalesSplittingLinePar.Type := Type;
          SalesSplittingLinePar."No." := "No.";
          SalesSplittingLinePar."Location Code" := "Location Code";
          SalesSplittingLinePar.Description := Description;
          SalesSplittingLinePar."Description 2" := "Description 2";
          SalesSplittingLinePar."Unit of Measure" := "Unit of Measure";
          SalesSplittingLinePar.Quantity := Quantity;
          SalesSplittingLinePar.Amount := Amount;
          SalesSplittingLinePar."Amount Including VAT" := "Amount Including VAT";
          SalesSplittingLinePar."Bill-to Customer No." := "Bill-to Customer No.";
          SalesSplittingLinePar."Currency Code" := "Currency Code";
          SalesSplittingLinePar."Dimension Set ID" := "Dimension Set ID";
          SalesSplittingLinePar."Line Type" := "Line Type";
          SalesSplittingLinePar.Include := FALSE;
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure CopyFldsSalesH2SplitLine(SalesHeaderPar: Record "36";var SalesSplittingLinePar: Record "25006042"): Integer
    begin
        WITH SalesHeaderPar DO BEGIN
          SalesSplittingLinePar.INIT;
          SalesSplittingLinePar."Document Type" := "Document Type";
          SalesSplittingLinePar."Document No." := "No.";
          SalesSplittingLinePar."Sell-to Customer No." := "Sell-to Customer No.";
          SalesSplittingLinePar."Line No." := 0;
          SalesSplittingLinePar."Location Code" := "Location Code";
          SalesSplittingLinePar.Description := Description;
          SalesSplittingLinePar.Amount := Amount;
          SalesSplittingLinePar."Amount Including VAT" := "Amount Including VAT";
          SalesSplittingLinePar."Bill-to Customer No." := "Bill-to Customer No.";
          SalesSplittingLinePar."Currency Code" := "Currency Code";
          SalesSplittingLinePar."Dimension Set ID" := "Dimension Set ID";
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure ChangeIncludeInfo(NewQty: Decimal)
    begin
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE("Document Type", "Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        SalesSplittingLine.SETRANGE("Line No.", "Line No.");
        SalesSplittingLine.SETFILTER("Temp. Document No.", '<>%1&<>%2', "Temp. Document No.", 0);
        SalesSplittingLine.SETRANGE(Include, Include);
        IF SalesSplittingLine.FINDFIRST THEN BEGIN
          SalesSplittingLine.VALIDATE("New Quantity", NewQty);
          SalesSplittingLine.Include := NOT Include;
          SalesSplittingLine.MODIFY;
        END;
    end;
}

