//
//  Coinbase.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

/// Strategy to configure auto-refresh mechanism.
///
/// - none: Disables auto-refresh.
///
///     **Note**
///
///     After access token gets expired all requests that require authorization will fail unless new
///     valid access token is provided.
///
///     To provide a new valid access token you should:
///     1. Get a new pair of tokens using `refresh()` method of `TokenResource`.
///     2. Set received access token into property of your `Coinbase` instance.
///
/// - refresh: Enables auto-refresh.
///
///     Whenever access token gets expired `Coinbase` will try to refresh it using the refresh token.
///     On every update of the token `onUserTokenUpdate` closure gets called. This is the place where you
///     can get a new pair of tokens which you can store in a secure permanent storage. You can use them
///     later to set up a new instance of Coinbase to keep user authorized between application sessions.
///
///     **Note**
///
///     Coinbase **does not store** any tokens in a *permanent* secure storage. To keep user authorized
///     between application sessions, it is recommended to store tokens in a secure storage and provide
///     them every time you setup a new instance of `Coinbase`.
///
///     **Important**
///
///     Enabling auto-refresh does not guarantee that requests won't fail with token not valid
///     error (e.g. token was revoked). It is highly recommended to handle such situations (e.g. to ask
///     user to log in again).
///
public enum TokenRefreshStrategy {
    /// Disables auto-refresh.
    ///
    /// - Note:
    ///
    ///     After access token gets expired all requests that require authorization will fail unless new
    ///     valid access token is provided.
    ///
    ///     To provide a new valid access token you should:
    ///     1. Get a new pair of tokens using `refresh()` method of `TokenResource`.
    ///     2. Set received access token into property of your `Coinbase` instance.
    ///
    case none
    /// Enables auto-refresh.
    ///
    /// Whenever access token gets expired `Coinbase` will try to refresh it using the refresh token.
    /// On every update of the token `onUserTokenUpdate` closure gets called. This is the place where you
    /// can get a new pair of tokens which you can store in a secure permanent storage. You can use them
    /// later to set up a new instance of Coinbase to keep user authorized between application sessions.
    ///
    /// - Note:
    ///
    ///     Coinbase **does not store** any tokens in a *permanent* secure storage. To keep user authorized
    ///     between application sessions, it is recommended to store tokens in a secure storage and provide
    ///     them every time you setup a new instance of `Coinbase`.
    ///
    /// - Important:
    ///
    ///     Enabling auto-refresh does not guarantee that requests won't fail with token not valid
    ///     error(e.g. token was revoked). It is highly recommended to handle such situations(e.g. to ask
    ///     user to log in again).
    ///
    case refresh(clientID: String, clientSecret: String, refreshToken: String, onUserTokenUpdate: ((UserToken?) -> Void)?)
}

open class Coinbase {
    
    /// Instanse of `Coinbase` with default configuration.
    public static let `default` = Coinbase()
    
    /// Session Manager to create and perfom requests with.
    public let sessionManager: SessionManagerProtocol
    
    /// Default base URL for all Coinbase resources.
    public let baseURL: String
    
    /// Provides lazily initialized instance of OAuth.
    ///
    /// - Important:
    ///     Call `configure` method to set all required properties before calling any authorization method.
    ///
    public lazy var oauth = OAuth(tokenResource: self.tokenResource)
    
    /// Access token for requests requiring authorization.
    public var accessToken: String? {
        get { return accessTokenProvider.accessToken }
        set { accessTokenProvider.accessToken = newValue }
    }
    
    // Token Resource uses specific base url for requests
    private lazy var _tokenResource = TokenResource(sessionManager: sessionManager, baseURL: NetworkConstants.baseURL, tokenListener: self)
    private lazy var _userResource = UserResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _currenciesResource = CurrenciesResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _exchangeRatesResource = ExchangeRatesResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _timeResource = TimeResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _pricesResource = PricesResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _accountResource = AccountResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _transactionResource = TransactionResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _paymentMethodResource = PaymentMethodResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _addressResource = AddressResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _buyResource = BuyResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _sellResource = SellResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _depositResource = DepositResource(sessionManager: sessionManager, baseURL: baseURL)
    private lazy var _withdrawalResource = WithdrawalResource(sessionManager: sessionManager, baseURL: baseURL)
    
    private var accessTokenProvider = AccessTokenProvider()
    private var tokenRefreshDataProvider: TokenRefreshDataProvider? {
        didSet {
            setupAutoRefreshInterceptor(dataProvider: tokenRefreshDataProvider)
        }
    }
    
    // MARK: - Initializer
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - accessToken: Access token for requests requring authorization.
    ///   - baseURL: Base url for requests.
    ///   - sessionManager: Session Manager to create and perfom requests with.
    ///
    public init(accessToken: String? = nil,
                baseURL: String = NetworkConstants.baseURLv2,
                sessionManager: SessionManagerProtocol = SessionManager()) {
        self.sessionManager = sessionManager
        self.baseURL = baseURL
        self.accessToken = accessToken
        
        self.sessionManager.accessTokenProvider = self.accessTokenProvider
    }
    
    // MARK: - Resources
    
    /// Provides lazily initialized instance of `TokenResource`.
    open var tokenResource: TokenResource {
        return _tokenResource
    }
    /// Provides lazily initialized instance of `UserResource`.
    open var userResource: UserResource {
        return _userResource
    }
    /// Provides lazily initialized instance of `CurrenciesResource`.
    open var currenciesResource: CurrenciesResource {
        return _currenciesResource
    }
    /// Provides lazily initialized instance of `ExchangeRatesResource`.
    open var exchangeRatesResource: ExchangeRatesResource {
        return _exchangeRatesResource
    }
    /// Provides lazily initialized instance of `TimeResource`.
    open var timeResource: TimeResource {
        return _timeResource
    }
    /// Provides lazily initialized instance of `PricesResource`.
    open var pricesResource: PricesResource {
        return _pricesResource
    }
    /// Provides lazily initialized instance of `TransactionResource`.
    open var transactionResource: TransactionResource {
        return _transactionResource
    }
    /// Provides lazily initialized instance of `AccountResource`.
    open var accountResource: AccountResource {
        return _accountResource
    }
    /// Provides lazily initialized instance of `PaymentMethodResource`.
    open var paymentMethodResource: PaymentMethodResource {
        return _paymentMethodResource
    }
    /// Provides lazily initialized instance of `AddressResource`.
    open var addressResource: AddressResource {
        return _addressResource
    }
    /// Provides lazily initialized instance of `BuyResource`.
    open var buyResource: BuyResource {
        return _buyResource
    }
    /// Provides lazily initialized instance of `SellResource`.
    open var sellResource: SellResource {
        return _sellResource
    }
    /// Provides lazily initialized instance of `DepositResource`.
    open var depositResource: DepositResource {
        return _depositResource
    }
    /// Provides lazily initialized instance of `WithdrawalResource`.
    open var withdrawalResource: WithdrawalResource {
        return _withdrawalResource
    }
    
}

// MARK: - Refresh functionality

extension Coinbase {
    
    // MARK: - Setup refresh
    
    /// Sets refresh strategy for `Coinbase SDK`.
    ///
    /// - Important:
    ///     After refresh token gets invalidated(e.g. revoked) to keep auto-refresh functionality
    ///     you should provide a new refresh token by setting refresh strategy again.
    ///
    /// - Parameter strategy: Refresh strategy to follow.
    ///
    public func setRefreshStrategy(_ strategy: TokenRefreshStrategy = .none) {
        switch strategy {
        case .none:
            self.tokenRefreshDataProvider = nil
        case let .refresh(clientID, clientSecret, refreshToken, onUpdate):
            self.tokenRefreshDataProvider = TokenRefreshDataProvider(clientID: clientID,
                                                                     clientSecret: clientSecret,
                                                                     refreshToken: refreshToken,
                                                                     onTokenUpdate: onUpdate)
        }
    }
    
    // MARK: - Private Methods
    
    /// Removes existing refresh interceptor and in case data provider is not nil creates
    /// and apends new refresh interceptor into an array of iterceprors.
    ///
    /// - Parameter dataProvider: Token refresh data provider.
    ///
    private func setupAutoRefreshInterceptor(dataProvider: TokenRefreshDataProvider?) {
        sessionManager.interceptors = sessionManager.interceptors.filter { !($0 is TokenAutoRefreshInterceptor) }
        guard let dataProvider = dataProvider else {
            return
        }
        let tokenAutoRefreshInterceptor = TokenAutoRefreshInterceptor(sessionManager: sessionManager,
                                                                      tokenResource: tokenResource,
                                                                      dataProvider: dataProvider)
        sessionManager.interceptors.append(tokenAutoRefreshInterceptor)
    }
    
}

// MARK: - Extension conforming to UserTokenListener

extension Coinbase: UserTokenListener {
    
    public func onUpdate(token: UserToken?) {
        tokenRefreshDataProvider?.onTokenUpdate?(token)
        accessToken = token?.accessToken
        if let refreshToken = token?.refreshToken {
            tokenRefreshDataProvider?.refreshToken = refreshToken
        } else {
            setRefreshStrategy(.none)
        }
    }
    
}
