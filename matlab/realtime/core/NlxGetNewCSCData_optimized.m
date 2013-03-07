%NLXGETNEWCSCDATA   Gets new CSC records that have been streamed over netcom
%
%   [succeeded, dataArray, timeStampArray, channelNumberArray, samplingFreqArray, numValidSamplesArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewCSCData(objectName)
%
%   Example:   [succeeded, dataArray, timeStampArray, channelNumberArray, samplingFreqArray, numValidSamplesArray, numRecordsReturned, numRecordsDropped ] = NlxGetNewCSCData('CSC1')
%		Returns the data for all the records recieved for CSC1 since the last call to this function.	
%
%	Returns:
%	succeeded:	1 means the operation completed successfully
%			0 means the operation failed
%	dataArray:  Continuous (e.g. not separated into records) array of samples returned from a get data function call for all received records since the last call to this function.  
%		          Each MAX_CSC_SAMPLES chunk of data will be associated with a single entry in the timestamp array.
%	timeStampArray:  Continuous array of timestamps for all received records since the last call to this function. 
%	channelNumberArray:  Continuous array of channel numbers  for all received records since the last call to this function.
%	samplingFreqArray:  Continuous array of sampling rates for all received records since the last call to this function.
%	numRecordsReturned:  The number of records that were received since the last call to this function
%	numRecordsDropped:  The number of records that wre dropped since the last call to this function.
%
%


function [succeeded,dataArrayRet, timeStampArray, channelNumberArray, samplingFreqArray, numValidSamplesArray, ...
    numRecordsReturned, numRecordsDropped ] = NlxGetNewCSCData_optimized(objectName, bufferSize,maxCSCSamples, dataArrayPtr)  

dataArrayRet=[];

	
	%succeeded = 1;

	%assume it is loaded

	%succeeded = libisloaded('MatlabNetComClient');
	%if succeeded == 0
%		disp 'Not Connected'
%		return;
%	end
	
	%bufferSize = calllib('MatlabNetComClient', 'GetRecordBufferSize');
	%maxCSCSamples = calllib('MatlabNetComClient', 'GetMaxCSCSamples');
	
    
    %set these fixed (faster)
    %bufferSize=1000;
  %  maxCSCSamples=512;
    
    %disp([ bufferSize maxCSCSamples]);
    
	%Clear out all of the return values and preallocate space for the variables
	
    
    %dataArray = zeros(1,(maxCSCSamples * bufferSize) );
    
    %dataArray = nan(1,(maxCSCSamples * bufferSize) );  %faster
	
    
    timeStampArray = zeros(1,bufferSize);
	channelNumberArray = zeros(1,bufferSize);
	samplingFreqArray = zeros(1,bufferSize);
	numValidSamplesArray = zeros(1,bufferSize);
	numRecordsReturned = 0;
	numRecordsDropped = 0;
	
	
	%setup the ref pointers for the function call
	
    %dataArrayPtr = libpointer('int16PtrPtr', dataArray);
	
    timeStampArrayPtr = libpointer('int64PtrPtr', timeStampArray);
	channelNumberArrayPtr = libpointer('int32PtrPtr', channelNumberArray);
	samplingFreqArrayPtr = libpointer('int32PtrPtr', samplingFreqArray);
	numValidSamplesArrayPtr = libpointer('int32PtrPtr', numValidSamplesArray);
	numRecordsReturnedPtr = libpointer('int32Ptr', numRecordsReturned);
	numRecordsDroppedPtr = libpointer('int32Ptr', numRecordsDropped);
    
    %if succeeded == 1
        [succeeded, ~, timeStampArray, channelNumberArray, samplingFreqArray,numValidSamplesArray, dataArray, numRecordsReturned, numRecordsDropped ] = calllib('MatlabNetComClient', 'GetNewCSCData', objectName, timeStampArrayPtr, channelNumberArrayPtr, samplingFreqArrayPtr, numValidSamplesArrayPtr, dataArrayPtr, numRecordsReturnedPtr,numRecordsDroppedPtr );
        
        %turncate arrays to the number of returned records
        if numRecordsReturned > 0
            dataArrayRet = dataArray(1:(numRecordsReturned * maxCSCSamples) );
            timeStampArray = timeStampArray(1:numRecordsReturned);
            channelNumberArray = channelNumberArray(1:numRecordsReturned);
            samplingFreqArray = samplingFreqArray(1:numRecordsReturned);
            numValidSamplesArray = numValidSamplesArray(1:numRecordsReturned);
        end;
   % end
    
end