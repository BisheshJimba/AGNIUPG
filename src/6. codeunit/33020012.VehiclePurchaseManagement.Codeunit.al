codeunit 33020012 "Vehicle Purchase Management"
{

    trigger OnRun()
    begin
    end;

    var
        GblPurchHdr: Record "38";
        GblDocAppCheckPost: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;

    [Scope('Internal')]
    procedure CheckVCPurchLine(PrmPurchHdr: Record "38")
    var
        LclPurchLine: Record "39";
        LclLCDetail: Record "33020012";
        LclLCVehTrack: Record "33020016";
        LclLCADetail: Record "33020013";
        LclLCAVehTrack: Record "33020017";
        Text33020011: Label 'LC vehicle tracking details doesnot exist. Please check LC No. - %1 for Vehicle Tracking.  ';
        Text33020012: Label 'VC No. doesnot match. Please check LC No. - %1!';
        Text33020013: Label 'LC Amend details doesnot exit. Please check LC No. - %1 for Amendments.';
        Text33020014: Label 'VC No. doesnot match. Please check LC No. - %1 and LC Amendment No. - %2!';
    begin
        //Code to check for VC No. match and no. of vehicle.
        LclPurchLine.RESET;
        LclPurchLine.SETRANGE("Document Type", PrmPurchHdr."Document Type");
        LclPurchLine.SETRANGE("Document No.", PrmPurchHdr."No.");
        IF LclPurchLine.FIND('-') THEN BEGIN
            REPEAT
                IF (LclPurchLine."Qty. to Receive" <> 0) THEN BEGIN
                    LclLCDetail.RESET;
                    LclLCDetail.SETRANGE("No.", PrmPurchHdr."Sys. LC No.");
                    IF LclLCDetail.FIND('-') THEN BEGIN
                        IF NOT LclLCDetail."Has Amendment" THEN BEGIN
                            LclLCVehTrack.RESET;
                            LclLCVehTrack.SETCURRENTKEY("No.", "VC No."); //Current keys are LC Details No. and VC No.
                            LclLCVehTrack.SETRANGE("No.", PrmPurchHdr."Sys. LC No.");
                            LclLCVehTrack.SETRANGE("VC No.", LclPurchLine."Variant Code");
                            IF NOT LclLCVehTrack.FIND('-') THEN
                                ERROR(Text33020012, LclPurchLine."Sys. LC No.");
                        END ELSE BEGIN
                            PrmPurchHdr.TESTFIELD("LC Amend No.");
                            LclLCADetail.RESET;
                            LclLCADetail.SETRANGE("Version No.", PrmPurchHdr."LC Amend No.");
                            LclLCADetail.SETRANGE("No.", PrmPurchHdr."Sys. LC No.");
                            IF LclLCADetail.FIND('+') THEN BEGIN
                                LclLCAVehTrack.RESET;
                                LclLCAVehTrack.SETCURRENTKEY("Version No.", "No.", "VC No.");
                                LclLCAVehTrack.SETRANGE("Version No.", PrmPurchHdr."LC Amend No.");
                                LclLCAVehTrack.SETRANGE("No.", PrmPurchHdr."Sys. LC No.");
                                LclLCAVehTrack.SETRANGE("VC No.", LclPurchLine."Variant Code");
                                IF NOT LclLCAVehTrack.FIND('-') THEN
                                    ERROR(Text33020014, PrmPurchHdr."Sys. LC No.", PrmPurchHdr."LC Amend No.");
                            END ELSE
                                ERROR(Text33020013, PrmPurchHdr."Sys. LC No.");
                        END;
                    END ELSE
                        ERROR(Text33020011, PrmPurchHdr."Sys. LC No.");
                END;
            UNTIL LclPurchLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CheckVCWiseQty(PrmPurchHdr: Record "38")
    var
        LclPurchLine: Record "39";
        LclLCDetail: Record "33020012";
        LclLCVehTrack: Record "33020016";
        LclLCADetail: Record "33020013";
        LclLCAVehTrack: Record "33020017";
        LclPurchLineNoOfVeh: Decimal;
        LclLCNoOfVeh: Decimal;
        Text33020011: Label 'No. of Vehicle in Purchase Order doesnot match with No. of Vehicle in LC Details. Please check LC No. - %1 and VC No. - %2! No. of Vehicle in LC Detail - %3 and Purchase Order - %4.';
        LclLCANoOfVeh: Decimal;
        Text33020012: Label 'No. of Vehicle in Purchase Order doesnot match with No. of Vehicle in LC Amendment Details. Please check LC Amendment No. - %1 and VC No. - %2! No. of Vehicle in LC Amendment Detail - %3 and Purchase Order - %4.';
    begin
        /*
        WITH PrmPurchHdr DO BEGIN
          LclLCDetail.RESET;
          LclLCDetail.SETRANGE("No.",PrmPurchHdr."Sys. LC No.");
          IF LclLCDetail.FIND('-') THEN BEGIN
            IF NOT LclLCDetail."Has Amendment" THEN BEGIN    //If doesnot have amendments then run this part of code.
              LclLCVehTrack.RESET;
              LclLCVehTrack.SETRANGE("No.",LclLCDetail."No.");
              IF LclLCVehTrack.FIND('-') THEN BEGIN
                LclLCNoOfVeh := 0;
                REPEAT
                  LclLCNoOfVeh := LclLCVehTrack."No. of Vehicle";
                  LclPurchLineNoOfVeh := 0;
                  LclPurchLine.RESET;
                  LclPurchLine.SETRANGE("Document Type",PrmPurchHdr."Document Type");
                  LclPurchLine.SETRANGE("Document No.",PrmPurchHdr."No.");
                  IF LclPurchLine.FIND('-') THEN BEGIN
                    LclPurchLine.CALCFIELDS("Sys. LC No.");
                    LclPurchLine.SETRANGE("Sys. LC No.",LclLCVehTrack."No.");
                    LclPurchLine.SETRANGE("VC No.",LclLCVehTrack."VC No.");
                    IF LclPurchLine.FIND('-') THEN BEGIN
                      REPEAT
                        LclPurchLineNoOfVeh := LclPurchLineNoOfVeh + LclPurchLine."Quantity Invoiced";
                      UNTIL LclPurchLine.NEXT = 0;
                      IF (LclLCNoOfVeh <> LclPurchLineNoOfVeh) THEN
                        MESSAGE(Text33020011,LclLCVehTrack."No.",LclLCVehTrack."VC No.",LclLCNoOfVeh,LclPurchLineNoOfVeh);
                    END;
                  END;
                UNTIL LclLCVehTrack.NEXT = 0;
              END;
            END ELSE BEGIN
              //If LC has amendment, code to check qty goes here with LC Amend - Vehicle tracking.
              LclLCADetail.RESET;
              LclLCADetail.SETRANGE("No.",LclLCDetail."No.");
              LclLCADetail.SETRANGE("Version No.",PrmPurchHdr."LC Amend No.");
              IF LclLCADetail.FIND('+') THEN BEGIN
                LclLCAVehTrack.RESET;
                LclLCAVehTrack.SETRANGE("Version No.",LclLCADetail."Version No.");
                LclLCAVehTrack.SETRANGE("No.",LclLCADetail."No.");
                IF LclLCAVehTrack.FIND('-') THEN BEGIN
                  LclLCANoOfVeh := 0;
                  REPEAT
                    LclLCANoOfVeh := LclLCAVehTrack."No. of Vehicle";
                    LclPurchLineNoOfVeh := 0;
                    LclPurchLine.RESET;
                    LclPurchLine.SETRANGE("Document Type",PrmPurchHdr."Document Type");
                    LclPurchLine.SETRANGE("Document No.",PrmPurchHdr."No.");
                    IF LclPurchLine.FIND('-') THEN BEGIN
                      LclPurchLine.CALCFIELDS("Sys. LC No.","LC Amend No.");
                      LclPurchLine.SETRANGE("LC Amend No.",LclLCAVehTrack."Version No.");
                      LclPurchLine.SETRANGE("Sys. LC No.",LclLCAVehTrack."No.");
                      LclPurchLine.SETRANGE("VC No.",LclLCAVehTrack."VC No.");
                      IF LclPurchLine.FIND('-') THEN BEGIN
                        REPEAT
                          LclPurchLineNoOfVeh := LclPurchLineNoOfVeh + LclPurchLine.Quantity;
                        UNTIL LclPurchLine.NEXT = 0;
                        IF (LclLCANoOfVeh <> LclPurchLineNoOfVeh) THEN
                          MESSAGE(Text33020012,LclLCAVehTrack."No.",LclLCAVehTrack."VC No.",LclLCANoOfVeh,LclPurchLineNoOfVeh);
                      END;
                    END;
                  UNTIL LclLCVehTrack.NEXT = 0;
                END;
              END;
            END;
          END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure CheckTolerancePercent(PrmPurchHdr: Record "38")
    var
        LclPurchLine: Record "39";
        LclLCDetail: Record "33020012";
        LclLCVehTrack: Record "33020016";
        LclLCADetail: Record "33020013";
        LclLCAVehTrack: Record "33020017";
        LclLCTotalAmt: Decimal;
        LclPurchLineAmt: Decimal;
        "LclLCDetTole%": Decimal;
        "LclLCADetTole%": Decimal;
        LclDiffAmount: Decimal;
        LclToleAmount: Decimal;
        Text33020011: Label 'Amount in lines doesnot match with the total amount in LC Vehicle Tracking lines. (Amount exceed Tolerance %). Please check LC No. - %1 for Tolerance %. ';
        Text33020012: Label 'Amount in lines doesnot match with the total amount in LC Vehicle Tracking lines. (Amount  is lesser then the amount in LC). Please check LC No. - %1 for Tolerance %. ';
        Text33020013: Label 'Please get approval from Finance Department.';
        LclPurchHdr: Record "38";
        LclApproved: Boolean;
    begin
        //Code to check tolerance percentage for LC Value changes in PI.
        //Code to calculate total amount in Purchase Line.
        LclPurchHdr.RESET;
        LclPurchHdr.SETRANGE("Document Type", PrmPurchHdr."Document Type");
        LclPurchHdr.SETRANGE("No.", PrmPurchHdr."No.");
        IF LclPurchHdr.FIND('-') THEN BEGIN
            LclPurchLine.RESET;
            LclPurchLine.SETRANGE("Document Type", PrmPurchHdr."Document Type");
            LclPurchLine.SETRANGE("Document No.", PrmPurchHdr."No.");
            IF LclPurchLine.FIND('-') THEN BEGIN
                REPEAT
                    LclPurchLineAmt := LclPurchLineAmt + LclPurchLine."Line Amount";
                UNTIL LclPurchLine.NEXT = 0;
            END;

            //Code to calculate total amount in LC Vehicle Tracking line.
            LclLCDetail.RESET;
            LclLCDetail.SETRANGE("No.", PrmPurchHdr."Sys. LC No.");
            IF LclLCDetail.FIND('-') THEN BEGIN
                IF NOT LclLCDetail."Has Amendment" THEN BEGIN
                    "LclLCDetTole%" := LclLCDetail."Tolerance Percentage";
                    LclLCVehTrack.RESET;
                    LclLCVehTrack.SETRANGE("No.", LclLCDetail."No.");
                    IF LclLCVehTrack.FIND('-') THEN BEGIN
                        REPEAT
                            LclLCTotalAmt := LclLCTotalAmt + LclLCVehTrack."Total Amount";
                        UNTIL LclLCVehTrack.NEXT = 0;
                    END;
                END ELSE BEGIN
                    LclLCADetail.RESET;
                    LclLCADetail.SETRANGE("No.", LclLCDetail."No.");
                    LclLCADetail.SETRANGE("Version No.", PrmPurchHdr."LC Amend No.");
                    IF LclLCADetail.FIND('+') THEN BEGIN
                        "LclLCADetTole%" := LclLCADetail."Tolerance Percentage";
                        LclLCAVehTrack.RESET;
                        LclLCAVehTrack.SETRANGE("Version No.", LclLCADetail."Version No.");
                        LclLCAVehTrack.SETRANGE("No.", LclLCADetail."No.");
                        IF LclLCAVehTrack.FIND('-') THEN BEGIN
                            REPEAT
                                LclLCTotalAmt := LclLCTotalAmt + LclLCAVehTrack."Total Amount";
                            UNTIL LclLCAVehTrack.NEXT = 0;
                        END;
                    END;
                END;
            END;

            //Calculating Total difference in amount.
            LclDiffAmount := LclLCTotalAmt - LclPurchLineAmt;

            //Calculating Tolerance Percentage.
            IF ("LclLCDetTole%" <> 0) THEN
                LclToleAmount := ((LclLCTotalAmt / 100) * "LclLCDetTole%")
            ELSE
                IF ("LclLCADetTole%" <> 0) THEN
                    LclToleAmount := ((LclLCTotalAmt / 100) * "LclLCADetTole%");

            IF (LclDiffAmount > LclToleAmount) THEN BEGIN
                //Code to check for approval entry goes here.
                LclApproved := GblDocAppCheckPost.checkDocApplWithBoolRet(DATABASE::"Purchase Header", GblDocType::LC, PrmPurchHdr."No.");
                IF NOT LclApproved THEN
                    ERROR(Text33020011, PrmPurchHdr."Sys. LC No.");
            END ELSE
                IF (LclDiffAmount < LclToleAmount) THEN BEGIN
                    //Code to check for approval entry goes here.
                    LclApproved := GblDocAppCheckPost.checkDocApplWithBoolRet(DATABASE::"Purchase Header", GblDocType::LC, PrmPurchHdr."No.");
                    IF NOT LclApproved THEN
                        ERROR(Text33020012, PrmPurchHdr."Sys. LC No.");
                END;
        END;
    end;
}

