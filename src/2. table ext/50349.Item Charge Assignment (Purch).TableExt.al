tableextension 50349 tableextension50349 extends "Item Charge Assignment (Purch)"
{
    // 09.01.2014 EDMS P15
    //   * Type of "Vehicle Accounting Cycle No." changed from FlowField to Normal ones
    fields
    {
        modify("Document Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE(Document Type=FIELD(Document Type),
                                                              Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (DecimalPlaces) on ""Qty. to Assign"(Field 8)".

        modify("Applies-to Doc. No.")
        {
            TableRelation = IF (Applies-to Doc. Type=CONST(Order)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Purchase Header".No. WHERE (Document Type=CONST(Invoice))
                            ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Purchase Header".No. WHERE (Document Type=CONST(Return Order))
                            ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Purchase Header".No. WHERE (Document Type=CONST(Credit Memo))
                            ELSE IF (Applies-to Doc. Type=CONST(Receipt)) "Purch. Rcpt. Header".No.
                            ELSE IF (Applies-to Doc. Type=CONST(Return Shipment)) "Return Shipment Header".No.;
        }
        modify("Applies-to Doc. Line No.")
        {
            TableRelation = IF (Applies-to Doc. Type=CONST(Order)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                     Document No.=FIELD(Applies-to Doc. No.))
                                                                                                     ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Invoice),
                                                                                                                                                                                     Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                     ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Return Order),
                                                                                                                                                                                                                                                                          Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                          ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Credit Memo),
                                                                                                                                                                                                                                                                                                                                                              Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                              ELSE IF (Applies-to Doc. Type=CONST(Receipt)) "Purch. Rcpt. Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                              ELSE IF (Applies-to Doc. Type=CONST(Return Shipment)) "Return Shipment Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.));
        }
        field(50000;"Vehicle Serial No.";Code[20])
        {
            TableRelation = Vehicle."Serial No.";
        }
        field(50001;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            FieldClass = FlowField;
        }
        field(25006010;"Vehicle-Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                Model: Record "25006001";
                DocumentMgt: Codeunit "25006000";
                FillCustomer: Boolean;
            begin
                CALCFIELDS( VIN, "Make Code", "Model Code", "Model Version No.");   //09.01.2014 EDMS P15
            end;
        }
        field(25006020;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            FieldClass = Normal;
        }
        field(25006030;"VIN Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle-Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                bFillCustomer: Boolean;
            begin
            end;
        }
        field(25006040;"Make Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE (Serial No.=FIELD(Vehicle-Serial No.)));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050;"Model Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE (Serial No.=FIELD(Vehicle-Serial No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006060;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Item.No. WHERE (Item Type=CONST(Model Version),
                                                 Make Code=FIELD(Make Code),
                                                 Model Code=FIELD(Model Code)));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

