tableextension 50332 tableextension50332 extends "Transfer Header"
{
    // 21.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Receipt Dimension Set ID"
    //   Added functions:
    //     ShowDocReceiptDim
    //     UpdateAllLineReceiptDim
    //     CreateReceiptDim
    //   Modified trigger:
    //     Transfer-to Code - OnValidate()
    fields
    {
        modify("Transfer-from Post Code")
        {
            TableRelation = IF (Trsf.-from Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Trsf.-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Trsf.-from Country/Region Code));
        }
        modify("Transfer-from City")
        {
            TableRelation = IF (Trsf.-from Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Trsf.-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Trsf.-from Country/Region Code));
        }
        modify("Transfer-to City")
        {
            TableRelation = IF (Trsf.-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Trsf.-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Trsf.-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 24)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Received"(Field 5753)".



        //Unsupported feature: Code Modification on ""No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              GetInventorySetup;
              NoSeriesMgt.TestManual(GetNoSeriesCode);
              "No. Series" := '';
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              GetInventorySetup;
              NoSeriesMgt.TestManual(GetNoSeriesCode2);
              "No. Series" := '';
            END;
            */
        //end;


        //Unsupported feature: Code Modification on ""Transfer-from Code"(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            IF ("Transfer-from Code" = "Transfer-to Code") AND
               ("Transfer-from Code" <> '')
            THEN
            #5..52
                EXIT;
              END;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TestStatusOpen;
            //SysMgt.IsLocationBlocked("Transfer-from Code",ProcessType::Transfer);
            CheckUserLocation;
            #2..55

            //Sipradi-YS GEN6.1.0 5740-1 BEGIN >> Get User Branch/Costcenter (Dimension)
            Location2.RESET;
            Location2.SETRANGE(Code,"Transfer-from Code");
            IF Location2.FINDFIRST THEN
              VALIDATE("Shortcut Dimension 1 Code",Location2."Shortcut Dimension 1 Code");

            IF UserSetup.GET(USERID) THEN BEGIN
              VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
            END;

            //Sipradi-YS GEN6.1.0 5740-1 END
            */
        //end;


        //Unsupported feature: Code Modification on ""Transfer-to Code"(Field 11).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            IF ("Transfer-from Code" = "Transfer-to Code") AND
               ("Transfer-to Code" <> '')
            THEN
            #5..47
                  MODIFY;
                END;
                UpdateTransLines(FIELDNO("Transfer-to Code"));
              END ELSE BEGIN
                "Transfer-to Code" := xRec."Transfer-to Code";
                EXIT;
              END;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TestStatusOpen;
            //SysMgt.IsLocationBlocked("Transfer-to Code",ProcessType::Transfer);

            #2..50

                //CreateReceiptDim(DATABASE::Location,"Transfer-to Code");              // 21.05.2014 Elva Baltic P21 #F182 MMG7.00
            #51..55
            */
        //end;
        field(50000;Remarks;Text[100])
        {
        }
        field(50002;Tender;Boolean)
        {
        }
        field(51010;"System Modified";Boolean)
        {
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Receipt Dimension Set ID";Integer)
        {
            Caption = 'receipt Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocReceiptDim;
            end;
        }
        field(25006010;"New Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1,' + Text107;
            Caption = 'New Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateNewShortcutDimCode(1,"New Shortcut Dimension 1 Code");
            end;
        }
        field(25006020;"New Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2,' + Text107;
            Caption = 'New Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateNewShortcutDimCode(2,"New Shortcut Dimension 2 Code");
            end;
        }
        field(25006100;"Transfer-to Customer No.";Code[20])
        {
            Caption = 'Transfer-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record "18";
            begin
                IF "Transfer-to Customer No." = '' THEN
                 BEGIN
                  "Transfer-to Customer Name" := '';
                  EXIT;
                 END;
                IF Cust.GET("Transfer-to Customer No.") THEN
                 "Transfer-to Customer Name" := Cust.Name;
            end;
        }
        field(25006110;"Transfer-to Customer Name";Text[30])
        {
            Caption = 'Transfer-to Customer Name';
        }
        field(25006160;"Source Type";Integer)
        {
            Caption = 'Source Type';
            Editable = false;

            trigger OnValidate()
            var
                TransferLine: Record "5741";
            begin
                TransferLine.RESET;
                TransferLine.SETRANGE("Document No.","No.");
                IF TransferLine.FINDFIRST THEN
                  ERROR(Text101,FIELDCAPTION("Source Type"),"No.");
            end;
        }
        field(25006166;"Source Subtype";Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";

            trigger OnValidate()
            var
                TransferLine: Record "5741";
            begin
                TransferLine.RESET;
                TransferLine.SETRANGE("Document No.","No.");
                IF TransferLine.FINDFIRST THEN
                  ERROR(Text101,FIELDCAPTION("Source Subtype"),"No.");

                VALIDATE("Source No.",'');
            end;
        }
        field(25006200;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(25006145)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Source Subtype));

            trigger OnValidate()
            var
                TransferLine: Record "5741";
            begin
                TransferLine.RESET;
                TransferLine.SETRANGE("Document No.","No.");
                IF TransferLine.FINDFIRST THEN
                  ERROR(Text101,FIELDCAPTION("Source No."),"No.");
            end;
        }
        field(25006210;"Combined Order";Boolean)
        {
            Caption = 'Combined Order';
        }
        field(33020235;"Vehicle Regd. No.";Code[20])
        {
            Editable = false;
        }
        field(33020236;"Courier Pod. No.";Code[30])
        {
        }
        field(33020237;"Courier Date";Date)
        {
        }
        field(33020238;Weight;Decimal)
        {
        }
        field(33020239;"Model Code";Code[20])
        {
        }
        field(33020240;"Job Open";Boolean)
        {
            CalcFormula = Exist("Service Header EDMS" WHERE (No.=FIELD(Source No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020241;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup("Service Header EDMS"."Model Version No." WHERE (No.=FIELD(Source No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020242;"Document Date";Date)
        {
        }
        field(33020601;"No. of Line Items";Integer)
        {
            CalcFormula = Count("Transfer Line" WHERE (Document No.=FIELD(No.),
                                                       Outstanding Quantity=FILTER(>0),
                                                       Transfer-from Code=FIELD(Transfer-from Code)));
            Description = 'MOBAPP1.00';
            FieldClass = FlowField;
        }
        field(33020602;"Total Qty. to Scan";Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Quantity" WHERE (Document No.=FIELD(No.),
                                                                            Transfer-from Code=FIELD(Transfer-from Code)));
            Description = 'MOBAPP1.00';
            FieldClass = FlowField;
        }
        field(33020603;"QR Image";BLOB)
        {
            Description = 'MOBAPP1.00';
            SubType = Bitmap;
        }
        field(33020604;"Picker ID";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(33020605;"Total CBM";Decimal)
        {
            CalcFormula = Sum("Transfer Line".CBM WHERE (Document No.=FIELD(No.)));
            DecimalPlaces = 0:6;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
        key(Key2;"Source Type","Source Subtype","Source No.","Document Profile")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GetInventorySetup;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        END;
        InitRecord;
        VALIDATE("Shipment Date",WORKDATE);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
          NoSeriesMgt.InitSeries(GetNoSeriesCode2,xRec."No. Series","Posting Date","No.","No. Series");
        #5..7
        VALIDATE("Assigned User ID",USERID); //--Surya
        "Document Date" := TODAY; // MIN  4/29/2019
        */
    //end;


    //Unsupported feature: Code Modification on "AssistEdit(PROCEDURE 1)".

    //procedure AssistEdit();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        WITH TransHeader DO BEGIN
          TransHeader := Rec;
          GetInventorySetup;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldTransHeader."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            Rec := TransHeader;
            EXIT(TRUE);
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode2,OldTransHeader."No. Series","No. Series") THEN BEGIN
        #6..10
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateAllLineDim(PROCEDURE 34)".

    //procedure UpdateAllLineDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT CONFIRM(Text007) THEN
          EXIT;

        TransLine.RESET;
        TransLine.SETRANGE("Document No.","No.");
        #10..20
              TransLine.MODIFY;
            END;
          UNTIL TransLine.NEXT = 0;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        //IF NOT CONFIRM(Text007) THEN
          //EXIT;
        #7..23
        */
    //end;


    //Unsupported feature: Code Modification on "VerifyShippedLineDimChange(PROCEDURE 71)".

    //procedure VerifyShippedLineDimChange();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF TransLine.IsShippedDimChanged THEN
          IF NOT ShippedLineDimChangeConfirmed THEN
            ShippedLineDimChangeConfirmed := TransLine.ConfirmShippedDimChange;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        {IF TransLine.IsShippedDimChanged THEN
          IF NOT ShippedLineDimChangeConfirmed THEN
            ShippedLineDimChangeConfirmed := TransLine.ConfirmShippedDimChange;
        }
        */
    //end;

    procedure ValidateNewShortcutDimCode(FieldNumber: Integer;NewShortcutDimCode: Code[20])
    var
        TransferLine: Record "5741";
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", "No.");
        IF NOT TransferLine.FINDFIRST THEN
          EXIT;

        IF NOT CONFIRM(Text102) THEN
          EXIT;

        CASE FieldNumber OF
          1:  TransferLine.MODIFYALL("From Location Dimension 1 Code", NewShortcutDimCode);
          2:  TransferLine.MODIFYALL("From Location Dimension 2 Code", NewShortcutDimCode);
        END;
    end;

    procedure ShowDocReceiptDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Receipt Dimension Set ID";
        "Receipt Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Receipt Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Receipt Dimension Set ID" THEN BEGIN
          MODIFY;
          IF TransferLinesExist THEN
            UpdateAllLineReceiptDim("Receipt Dimension Set ID",OldDimSetID);
        END;
    end;

    procedure UpdateAllLineReceiptDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
          EXIT;

        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT HideValidationDialog THEN
          IF NOT CONFIRM(Text007) THEN
            EXIT;

        TransLine.RESET;
        TransLine.SETRANGE("Document No.","No.");
        TransLine.LOCKTABLE;
        IF TransLine.FIND('-') THEN
          REPEAT
            IF (TransLine.Quantity = TransLine."Quantity Shipped") AND (TransLine.Quantity <> TransLine."Quantity Received") THEN BEGIN
              NewDimSetID := DimMgt.GetDeltaDimSetID(TransLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
              IF TransLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                TransLine."Dimension Set ID" := NewDimSetID;
                DimMgt.UpdateGlobalDimFromDimSetID(
                  TransLine."Dimension Set ID",TransLine."Shortcut Dimension 1 Code",TransLine."Shortcut Dimension 2 Code");
                TransLine.MODIFY;
              END;
            END;
          UNTIL TransLine.NEXT = 0;
    end;

    procedure CreateReceiptDim(Type1: Integer;No1: Code[20])
    var
        SourceCodeSetup: Record "242";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Receipt Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Transfer,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Receipt Dimension Set ID",DATABASE::Location);
    end;

    local procedure GetNoSeriesCode2(): Code[10]
    begin
        EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Transfer,DocumentType::Order));
    end;

    procedure GetLocationWiseRec(DocProfile: Option " ","Spare Parts Trade","Vehicles Trade",Service)
    begin
        Rec.RESET;
        SETRANGE("Document Profile",DocProfile);
        IF FINDFIRST THEN BEGIN
        UserSetup.GET(USERID);
          REPEAT
            IF ("Transfer-from Code" = UserSetup."Default Location") OR ("Transfer-from Code"='') OR
               ("Transfer-to Code" = UserSetup."Default Location") OR ("Transfer-to Code"='')THEN BEGIN
                  Rec.MARK(TRUE);
               END;
          UNTIL NEXT = 0;
        END;
    end;

    procedure GetLocationWiseRecWithMProfile(DocProfile: Text[100])
    begin
        Rec.RESET;
        SETFILTER("Document Profile",DocProfile);
        IF FINDFIRST THEN BEGIN
        UserSetup.GET(USERID);
          REPEAT
            IF ("Transfer-from Code" = UserSetup."Default Location") OR ("Transfer-from Code"='') OR
               ("Transfer-to Code" = UserSetup."Default Location") OR ("Transfer-to Code"='')THEN BEGIN
                  Rec.MARK(TRUE);
               END;
          UNTIL NEXT = 0;
        END;
    end;

    procedure CheckUserLocation()
    var
        UserSetup: Record "91";
        Text000: Label 'You are not authorised to transfer from %1. Please use ''User Personalization'' to change your Working Center if you want to work from %1.';
    begin
        IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN BEGIN
          UserSetup2.GET(USERID);
          IF "Transfer-from Code" <> UserSetup2."Default Location" THEN
            ERROR(Text000,"Transfer-from Code");
        END;
    end;

    procedure OnBeforePostTransferDocument(var TransHeader: Record "5740";LocationCode: Code[10])
    var
        Location: Record "14";
    begin
        TransHeader."System Modified" := TRUE;
        TransHeader.MODIFY(TRUE);
        Location.GET(LocationCode);
        Location.TESTFIELD("Shortcut Dimension 1 Code");
        IF Location."Shortcut Dimension 1 Code" <> '' THEN BEGIN
          TransHeader.VALIDATE("Shortcut Dimension 1 Code",Location."Shortcut Dimension 1 Code");
          TransHeader.MODIFY(TRUE);
        END;
    end;

    var
        Location2: Record "14";

    var
        Text101: Label 'You cannot change %1 while there exist transfer lines for transfer order %2.';
        Text102: Label 'Do you want to update the lines?';

    var
        Text107: Label 'New ';
        StplSysMgt: Codeunit "50000";
        DocumentProfile: Option Purchase,Sales,Service,Transfer;
        DocumentType: Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment";
        UserSetup: Record "91";
        UserSetup2: Record "91";
        SysMgt: Codeunit "50000";
        ProcessType: Option " ",Transfer,Purchase,Sales,All;
}

