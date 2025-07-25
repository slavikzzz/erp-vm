#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура обработчик обновления на версию "1.3.7.5"
//
Процедура ПеренестиПарольВБезопасноеХранилище() Экспорт
	
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК Настройка,
	|	ОбменССайтом.УдалитьПароль КАК Пароль
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	ОбменССайтом.УдалитьПароль <> """"
	|	И ОбменССайтом.Ссылка <> &ЭтотУзел";
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НачатьТранзакцию();
			
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("ПланОбмена.ОбменССайтом");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Настройка);
				Блокировка.Заблокировать();
				
				ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Выборка.Настройка, Выборка.Пароль);
			
				НастройкаОбъект = Выборка.Настройка.ПолучитьОбъект();
				НастройкаОбъект.УдалитьПароль = "";
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НастройкаОбъект, Ложь, Ложь);
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				
				ТекстСообщения = НСтр("ru = 'Не удалось обработать: %УзелПланаОбмена% по причине: %Причина%';
										|en = 'Cannot process: %УзелПланаОбмена% due to: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УзелПланаОбмена%", Выборка.Настройка);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Предупреждение,
					Метаданные.ПланыОбмена.ОбменССайтом, Выборка.Настройка, ТекстСообщения);
				
			КонецПопытки;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик обновления на версию "1.3.7.5"
//
Процедура ЗаполнитьРеквизитыНастройкиОбмена() Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК Настройка
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	ОбменССайтом.ВыгружатьТовары = ЛОЖЬ
	|	И ОбменССайтом.ВыгружатьЦеныОстатки = ЛОЖЬ
	|	И ОбменССайтом.ВыгружатьОбновленияЦенИОстатков = ЛОЖЬ
	|	И ОбменССайтом.Ссылка <> &ЭтотУзел";
	
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.ОбменССайтом.ЭтотУзел());
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НачатьТранзакцию();
			
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("ПланОбмена.ОбменССайтом");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Настройка);
				Блокировка.Заблокировать();
				
				
				НастройкаОбъект    = Выборка.Настройка.ПолучитьОбъект();
				ПараметрыНастройки = НастройкаОбъект.ПараметрыПрикладногоРешения.Получить();
				РежимВыгрузки      = НастройкаОбъект.УдалитьРежимВыгрузки;
				
				
				Если РежимВыгрузки = 0 Тогда
					
					НастройкаОбъект.ВыгружатьТовары = Истина;
					НастройкаОбъект.ВыгружатьЦеныОстатки = Истина;
					
				ИначеЕсли РежимВыгрузки = 1 Тогда
					НастройкаОбъект.ВыгружатьТовары = Истина;
					
				ИначеЕсли РежимВыгрузки = 2 Тогда
					НастройкаОбъект.ВыгружатьЦеныОстатки = Истина;
					
				КонецЕсли;
				
				НастройкаОбъект.ВидОтбораПоНоменклатуре = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
				
				КлассифицироватьПоВидамНоменклатуры = Неопределено;
				Если ПараметрыНастройки.Свойство("КлассифицироватьПоВидамНоменклатуры", КлассифицироватьПоВидамНоменклатуры)
					И КлассифицироватьПоВидамНоменклатуры = Истина Тогда
					
					НастройкаОбъект.ВидОтбораПоНоменклатуре = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
					
				ИначеЕсли КлассифицироватьПоВидамНоменклатуры = Неопределено Тогда
					
					Если РежимВыгрузки = 3 Тогда
						НастройкаОбъект.ВыгружатьОбновленияЦенИОстатков = Истина;
					КонецЕсли;
					
				КонецЕсли;
				
				// Удалим параметр "КлассифицироватьПоВидамНоменклатуры" из настроек, так как он больше не используется.
				Если ПараметрыНастройки.Свойство("КлассифицироватьПоВидамНоменклатуры") Тогда
					ПараметрыНастройки.Удалить("КлассифицироватьПоВидамНоменклатуры");
				КонецЕсли;
				
				НастройкаОбъект.ОбменДанными.Загрузка = Истина;
				
				НастройкаОбъект.Записать();;
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				
				ТекстСообщения = НСтр("ru = 'Не удалось обработать: %УзелПланаОбмена% по причине: %Причина%';
										|en = 'Cannot process: %УзелПланаОбмена% due to: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%УзелПланаОбмена%", Выборка.Настройка);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Предупреждение,
					Метаданные.ПланыОбмена.ОбменССайтом, Выборка.Настройка, ТекстСообщения);
				
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		ВыбраннаяФорма = "ФормаУзла";
		ОбменССайтомПереопределяемый.ПереопределитьФормуУзла(ВыбраннаяФорма);
		Если Не ВыбраннаяФорма = "ФормаУзла" Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

