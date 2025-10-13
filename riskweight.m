function answer = key()
    answer = "";
end

function address = HistoricalTable(ticker)
    address = "https://financialmodelingprep.com/api/v3/historical-price-full/" + ticker + "?from=2025-01-01&apikey=" + key();
end

function request = Request(ticker)
    options = weboptions('Timeout', 30, 'ContentType', 'json');
    data = webread(HistoricalTable(ticker), options);
    request = flip(data.historical);
end

function ror = RateOfReturn(close, n)
    m = length(close);
    result = zeros(m-1, n);
    for i=2:m
        for j=1:n
            result(i-1, j) = close(i, j) / close(i-1, j) - 1.0;
        end
    end
    ror = result;
end

portfolio = ["AAPL","PLTR","MSFT","NVDA","TSLA","JPM","WMT","SPY"];

close = [];
n = length(portfolio)

for i=1:n
    close = [Request(portfolio(i)).adjClose; close];
    pause(1.5);
    disp(portfolio(i));
end

close = close';
disp(close);
ror = RateOfReturn(close, n);

covar = cov(ror);
mu = mean(ror);

top = inv(covar)*mu';
bot = diag(ones(n))' * top

W = top / bot;

risk = sqrt(W' * covar * W);

chunk = W .* covar * W / risk;

bar(chunk, 'cyan', labels=portfolio);