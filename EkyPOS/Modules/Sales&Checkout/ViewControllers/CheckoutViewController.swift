//
//  CategoryProductViewController.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import Combine

class CheckoutViewController: UIViewController {
    
    private let cartViewModel = CartViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        return table
    }()

    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBrown
        button.tintColor = .label
        button.layer.cornerRadius = 8
        button.enableBounceAnimation()
        return button
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var totalUnitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private var checkoutModel = CheckoutModel(cartProducts: [], totalPrice: 0, totalUnit: 0)
    private var cartProductsTotalTemp: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Checkout"
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartProductTableViewCell.self, forCellReuseIdentifier: "CartProductCell")
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let rowPrice = LabelRowStack()
        let leftPriceLabel = UILabel()
        leftPriceLabel.text = "Total price"
        leftPriceLabel.font = .systemFont(ofSize: 16)
        leftPriceLabel.textColor = .label
        rowPrice.setLeftLabel(leftLabel: leftPriceLabel)
        rowPrice.setRightLabel(rightLabel: totalPriceLabel)
        stackView.addArrangedSubview(rowPrice)

        let rowUnit: LabelRowStack = LabelRowStack()
        let leftUnitLabel = UILabel()
        leftUnitLabel.text = "Total unit"
        leftUnitLabel.font = .systemFont(ofSize: 16)
        leftUnitLabel.textColor = .label
        rowUnit.setLeftLabel(leftLabel: leftUnitLabel)
        rowUnit.setRightLabel(rightLabel: totalUnitLabel)
        stackView.addArrangedSubview(rowUnit)

        actionButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.checkoutModel.cartProducts.isEmpty == false {
                let vc = PaymentViewController()
                vc.checkoutModel = self.checkoutModel
                if isTabletMode {
                    vc.modalPresentationStyle = .formSheet
                    self.present(vc, animated: true)
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                showToast(.info, title: "Info", message: "Please select at least one product")
            }
        }, for: .touchUpInside)

        bottomBar.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(bottomBar.snp.top).inset(20)
        }

        bottomBar.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomBar.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.top.equalTo(stackView.snp.bottom).offset(20)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        cartViewModel.cartProductsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] cartProducts in
                guard let self = self else { return }
                self.updateTotalPrice(cartProducts: cartProducts)
                self.updateTotalUnit(cartProducts: cartProducts)
                self.checkoutModel.cartProducts = cartProducts
                
                if UIDevice.current.userInterfaceIdiom == .pad && self.cartProductsTotalTemp != cartProducts.count {
                    self.cartProductsTotalTemp = cartProducts.count
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateTotalPrice(cartProducts: [CartProductModel]) {
        let price = cartProducts.reduce(0) { $0 + (($1.product?.price ?? 0) * Double($1.totalUnit)) }
        checkoutModel.totalPrice = price
        totalPriceLabel.text = rpCurrencyFormatter.string(from: price as NSNumber)
    }
    
    private func updateTotalUnit(cartProducts: [CartProductModel]) {
        let units = cartProducts.reduce(0) { $0 + $1.totalUnit }
        checkoutModel.totalUnit = units
        totalUnitLabel.text = String(units)
    }

    deinit {
        cancellables.removeAll()    
    }
    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CartProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CartProductCell", for: indexPath) as! CartProductTableViewCell
        cell.configure(with: cartViewModel.cartProducts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

