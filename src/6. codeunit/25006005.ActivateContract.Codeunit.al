codeunit 25006005 ActivateContract
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed Constant:
    //     Text000
    //   Modified procedure:
    //     ActivateContract


    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'It is not possible to set Status to Active because some Contract Sales Line Discount lines have zero %1.';

    [Scope('Internal')]
    procedure ActivateContract(FromServContractHeader: Record "25006016")
    var
        ServContractHeader: Record "25006016";
        ServContractLine: Record "25006017";
    begin
        ServContractHeader := FromServContractHeader;
        IF ServContractHeader.Status = ServContractHeader.Status::Active THEN
            EXIT;

        ServContractHeader.LOCKTABLE;

        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract No.", ServContractHeader."Contract No.");
        ServContractLine.SETRANGE("Line Discount %", 0);
        IF NOT ServContractLine.ISEMPTY THEN
            // ERROR(Text000,Status,ServContractLine.FIELDCAPTION("Line Discount %"));                                     // 16.04.2014 Elva Baltic P21
            ERROR(Text000, ServContractLine.FIELDCAPTION("Line Discount %"));                                              // 16.04.2014 Elva Baltic P21

        ServContractHeader.GET(FromServContractHeader."Contract Type", FromServContractHeader."Contract No.");
        ServContractHeader.Status := ServContractHeader.Status::Active;
        ServContractHeader.MODIFY;
    end;

    [Scope('Internal')]
    procedure InactivateContract(ServContractHeader: Record "25006016")
    begin
        IF ServContractHeader.Status = ServContractHeader.Status::Inactive THEN
            EXIT;
        ServContractHeader.LOCKTABLE;
        ServContractHeader.Status := ServContractHeader.Status::Inactive;
        ServContractHeader.MODIFY;
    end;
}

