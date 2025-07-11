#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытийФормы

// Клиентский обработчик проверки заполнения форм ГосИС
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - проверяемая форма
//   Отказ - Булево - Истина если проверка заполнения не пройдена
Процедура ПроверитьЗаполнение(Форма, Отказ) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "ОбщаяФорма.ФормаУточненияДанныхИС"
		Или Форма.ИмяФормы = "ОбщаяФорма.ФормаУточненияПодобраннойПродукцииИСМП" Тогда
		Если Не ЗначениеЗаполнено(Форма.Характеристика) И Форма.ХарактеристикиИспользуются Тогда
			Отказ = Истина;
		ИначеЕсли ЗначениеЗаполнено(Форма.Склад)
			И Не ЗначениеЗаполнено(Форма.Серия)
			И Не Форма.Элементы.Серия.ТолькоПросмотр
			И Форма.Элементы.Серия.ОтметкаНезаполненного Тогда
			Отказ = Истина;;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Обрабатывает нажатие на гиперссылку со статусом обработки в ИС.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло нажатие на гиперссылку,
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки,
//  СтандартнаяОбработка - Булево - признак стандартной (системной) обработки события.
//
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИС") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВидПродукции = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(Форма.Объект.ОсобенностьУчета);
		Если ОбщегоНазначенияИСКлиентСерверПовтИсп.ПоддерживаетсяЧастичноеВыбытие(ВидПродукции)
			Или ОбщегоНазначенияИСКлиентСервер.ЭтоМолочнаяПродукцияИСМП(ВидПродукции)
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.БезалкогольноеПиво")
			Или ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная")
			Или ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции) Тогда
			
			ОповещениеДействия = Новый ОписаниеОповещения(
				"ФормаНастройкиПараметровИСЗавершение",
				ИнтеграцияИСУТКлиент,
				Новый Структура("Форма",Форма));
			
			ПараметрыОбработкиДействия = ИнтеграцияИСКлиент.ПараметрыОткрытияФормыНастройкиНоменклатуры();
			ПараметрыОбработкиДействия.ЕдиницаХранения = Форма.Объект.ЕдиницаИзмерения;
			ПараметрыОбработкиДействия.ФормаВладелец   = Форма;
			ПараметрыОбработкиДействия.Номенклатура    = Форма.Объект.Ссылка;
			ПараметрыОбработкиДействия.ВидПродукции    = ВидПродукции;
			
			ПараметрыОбработкиДействия.ДопустимаНастройкаЛогистическойЕдиницы = ВидПродукции <> ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
			ПараметрыОбработкиДействия.КарточкаТовараСодержитВесовойПризнак   = Форма.Объект.ВесИспользовать Или Форма.Объект.ОбъемИспользовать;
			ПараметрыОбработкиДействия.УпаковкиВключены                       = Истина;
			
			Если НавигационнаяСсылкаФорматированнойСтроки = "ГиперссылкаОткрытьФормуНастройкиПараметровНоменклатурыИСДляПросмотра" Тогда
				ПараметрыОбработкиДействия.РежимПросмотра = Истина;
			КонецЕсли;
			
			ИнтеграцияИСКлиент.ОбработкаДействияНастройкиНоменклатуры(
				ОповещениеДействия,
				ПараметрыОбработкиДействия);
		
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Обработчики событий обрабатываемых БГосИС в прикладных формах
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - оповещаемая форма,
//  ИмяСобытия              - Строка           - имя события,
//  Параметр                - Произвольный     - параметр сообщения. Могут быть переданы любые необходимые данные,
//  Источник                - Произвольный     - источник события.
//  ДополнительныеПараметры - Структура        - дополнительные параметры обработки
Процедура ОбработкаОповещенияИС(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Источник = "ПодключаемоеОборудование" И Форма.ВводДоступен() Тогда
			Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
				Если Форма.ИспользоватьАкцизныеМарки Тогда
					
					ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
					МенеджерОборудованияУТКлиент.ОбработатьСобытие();
					ДанныеШтрихкода = МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр);
					//@skip-warning обработчики в явно заданных формах есть
					ОписаниеОповещения = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", Форма);
					ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкода);
					
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Источник = "ПодключаемоеОборудование" И ИмяСобытия = "НеизвестныеШтрихкоды" 
			И Форма.ИспользоватьАкцизныеМарки Тогда
			
			ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
			
		КонецЕсли;
			
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

//Переопределенный сценарий обработки оповещения прикладных объектов об изменениях в библиотечных.
//   Вызывается для обновления гиперссылок в прикладных документах и при необходимости выполнить дополнительные действия.
//   Для переопределения обработчика установить Событие.Обработано = Истина, для дополнения не менять это значение.
// 
// Параметры:
//   МестоВызова - Структура - сведения о месте в котором требуется обработка:
//    * Форма  - ФормаКлиентскогоПриложения     - источник вызова
//    * Объект - ДанныеФормыСтруктура - основной реквизит формы
//   Событие     - Структура - сведения о событии:
//    * Имя        - Строка       - имя события формы
//    * Параметр   - Произвольный - параметр события формы
//    * Источник   - Произвольный - источник события формы
//    * Обработано - Булево       - признак что событие уже обработано
//
Процедура ОбработкаОповещенияВФормеДокументаОснования(МестоВызова, Событие) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения - форма, в которой расположена команда
//  Команда                 - КомандаФормы     - команда формы
//  ДополнительныеПараметры - Структура        - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКомандуИС(Форма, Команда, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
	
		Если Форма.Объект.Товары.Количество() Тогда
			ДобавленныеВидыПродукции = ИнтеграцияИСВызовСервераУТ.ВидыПродукцииВТоварах(Форма.Объект.Товары);
		Иначе
			ДобавленныеВидыПродукции = Новый Массив;
		КонецЕсли;
		
		АлкогольнаяПродукция = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
		
		Если ДобавленныеВидыПродукции.Количество() = 0 Тогда
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
				ДобавленныеВидыПродукции.Добавить(АлкогольнаяПродукция);
			КонецЕсли;
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП")<>Неопределено Тогда
				Для Каждого ВидПродукции Из Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП").ВидыПродукции Цикл
					ДобавленныеВидыПродукции.Добавить(ВидПродукции);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ДобавленныеВидыПродукции.Количество() = 1 Тогда
			
			ВидПродукции = ДобавленныеВидыПродукции[0];
			Если ВидПродукции = АлкогольнаяПродукция Тогда
				Команда = Новый Структура("Имя", "ПроверитьАкцизныеМаркиЕГАИС");
			Иначе
				Команда = Новый Структура("Имя",
					СтрШаблон("ПроверитьАкцизныеМаркиГосИС%1",
						ОбщегоНазначенияИСКлиентСервер.ИндексВидаПродукцииИС(ВидПродукции)));
			КонецЕсли;
			
		Иначе
			
			Команда = Новый Структура("Имя", "");
			
			Если ДобавленныеВидыПродукции.Количество() Тогда
				
				СписокВыбора = Новый СписокЗначений;
				Если ДобавленныеВидыПродукции.Найти(АлкогольнаяПродукция) <> Неопределено Тогда
					СписокВыбора.Добавить(АлкогольнаяПродукция, НСтр("ru = 'Алкогольная продукция';
																	|en = 'Алкогольная продукция'"));
				КонецЕсли;
				
				Для Каждого ВидПродукцииИС Из ОбщегоНазначенияИСКлиентСервер.ВидыПродукцииИСМП(Истина) Цикл
					Если ДобавленныеВидыПродукции.Найти(ВидПродукцииИС) <> Неопределено Тогда
						СписокВыбора.Добавить(ВидПродукцииИС, "" + ВидПродукцииИС);
					КонецЕсли;
				КонецЦикла;
				
				ПараметрыФормы = Новый Структура("СписокВыбора", СписокВыбора);
				
				ДополнительныеПараметры = Новый Структура("Форма", Форма);
				ОповещениеОВыборе = Новый ОписаниеОповещения("ОбработатьВыборФормыСканирования", ИнтеграцияИСУТКлиент, ДополнительныеПараметры);
				ОткрытьФорму("ОбщаяФорма.ФормаВыбораВидовПродукцииГосИС",
					ПараметрыФормы,
					Форма,,,,
					ОповещениеОВыборе,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Команда.Имя = "ЗаполнитьПоДокументамМаркировки" Тогда
		
		ДополнительныеПараметры = Новый Структура("Форма", Форма);
		ОповещениеОВыборе = Новый ОписаниеОповещения("ОбработатьВыборДокументовМаркировки", ИнтеграцияИСУТКлиент, ДополнительныеПараметры);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОткрытьФорму("Документ.МаркировкаТоваровИСМП.Форма.ФормаСпискаДокументов",
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор,,,
			ОповещениеОВыборе,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Обработчики БГосИС элементов прикладных форм
//   Ограничения: не предполагает контекстный серверный вызов.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный - элемент-источник события "При изменении". Может быть любой идентификатор (примеры: поле ввода, строка).
//   ДополнительныеПараметры - Структура    - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	
	//Отменим постобработку штрихкода, если она уже произведена для маркируемой продукции
	Если Элемент = "ПослеОбработкиШтрихкодов" Тогда
		Индекс = ДополнительныеПараметры.ДанныеДляОбработки.ТекущаяСтрока;
		Если Индекс <> Неопределено Тогда
			ДанныеСтроки = Форма.Элементы.Товары.ДанныеСтроки(Индекс);
			Если ДанныеСтроки <> Неопределено И ДанныеСтроки.МаркируемаяПродукция Тогда
				ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Элемент = "ПраваДоступа" Тогда
			
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС") <> Неопределено Тогда
				Форма.Элементы.ТоварыНоменклатураЕГАИС.ТолькоПросмотр = Не Форма.ПраваДоступа.КорректировкаСтрок;
			КонецЕсли;
			
		ИначеЕсли Элемент = "ТоварыПоискПоШтрихкоду" Тогда
			
			Если Форма.ИспользоватьАкцизныеМарки
				И ДополнительныеПараметры.ДанныеШтрихкода <> Неопределено Тогда
				
				ДополнительныеПараметры.ТребуетсяСерверныйВызов = Истина;
				ДополнительныеПараметры.Вставить("ПараметрыСканирования", ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(Форма));
				ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ЗакодироватьШтрихкодДанныхBase64(ДополнительныеПараметры.ДанныеШтрихкода);
				ДополнительныеПараметры.СтандартнаяОбработка = Ложь;
				
			КонецЕсли;
			
		ИначеЕсли Элемент = "ЗавершитьОбработкуШтрихкода" Тогда
			
			Если Форма.ИспользоватьАкцизныеМарки Тогда
				
				ПараметрыЗавершенияВводаШтрихкода = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыЗавершенияОбработкиШтрихкода(, "ПоискПоШтрихкодуЗавершение","");
				ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода  = ДополнительныеПараметры.РезультатОбработкиШтрихкода;
				ПараметрыЗавершенияВводаШтрихкода.Форма                        = Форма;
				ПараметрыЗавершенияВводаШтрихкода.ПараметрыСканирования        = ДополнительныеПараметры.ПараметрыСканирования;
				ПараметрыЗавершенияВводаШтрихкода.ДанныеШтрихкода              = ДополнительныеПараметры.ДанныеШтрихкода;
				
				ШтрихкодированиеОбщегоНазначенияИСКлиент.ЗавершитьОбработкуШтрихкода(ПараметрыЗавершенияВводаШтрихкода);
				ШтрихкодированиеОбщегоНазначенияИСКлиент.ОбработатьАсинхронноШтрихкод(ПараметрыЗавершенияВводаШтрихкода);
				
			КонецЕсли;
			
		ИначеЕсли Элемент = "Подключаемый_ОткрытьФормуУточненияДанных" Тогда
			
			Если Форма.ИспользоватьАкцизныеМарки Тогда
				
				//@skip-warning обработчики в явно заданных формах есть
				ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(Форма, Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", Форма));
				
			КонецЕсли;
			
		ИначеЕсли Элемент = "ПроверитьКоличествоВДокументе" Тогда
			
			Если Форма.ИспользоватьАкцизныеМарки Тогда
				Для Каждого СтрокаТЧ Из Форма.Объект.Товары Цикл
					Если ПустаяСтрока(СтрокаТЧ.ИдентификаторСтроки) И СтрокаТЧ.МаркируемаяПродукция = 1 Тогда
						СтрокаТЧ.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			ДополнительныеПараметры.Вставить("ИспользоватьАкцизныеМарки", Форма.ИспользоватьАкцизныеМарки);
			ДополнительныеПараметры.Вставить("ОрганизацияЕГАИС",          Форма.Объект.ОрганизацияЕГАИС);
			
		ИначеЕсли Элемент = "Товары" Тогда
			
			Если ДополнительныеПараметры.Свойство("ПередУдалением") Тогда
				Форма.ТребуетсяПересчетМарокПослеУдаленияСтрок = Ложь;
				Для Каждого СтрокаТовары Из Форма.Элементы.Товары.ВыделенныеСтроки Цикл
					Если Форма.Элементы.Товары.ДанныеСтроки(СтрокаТовары).МаркируемаяПродукция Тогда
						Форма.ТребуетсяПересчетМарокПослеУдаленияСтрок = Истина;
					КонецЕсли;
				КонецЦикла;
				Возврат;
			КонецЕсли;
			
			Если ДополнительныеПараметры.Свойство("ПослеУдаления") Тогда
				ДополнительныеПараметры.ТребуетсяСерверныйВызов = Форма.ТребуетсяПересчетМарокПослеУдаленияСтрок
					И Форма.Объект.АкцизныеМарки.Количество();
				Возврат;
			КонецЕсли;
			
			ТекущаяСтрока = Форма.Элементы.Товары.ТекущиеДанные;
			Если (ТекущаяСтрока = Неопределено) Тогда
				Возврат;
			КонецЕсли;
			
			НужноПересчитатьКеш = ПроверкаИПодборПродукцииИСКлиент.ПрименитьКешПоСтроке(
				Форма, Форма.Объект.Товары, ТекущаяСтрока, Форма.КэшированныеСтроки.Товары);
			
			Если НужноПересчитатьКеш Тогда
				ДополнительныеПараметры.Вставить("ТребуетсяСерверныйВызов");
			КонецЕсли;
			
		ИначеЕсли Элемент = "ОбработкаКодаМаркировкиВыполнитьДействие" Тогда
			
			ПараметрыСерверногоВызова = Новый Структура;
			ПараметрыСерверногоВызова.Вставить("РезультатВыбора");
			ПараметрыСерверногоВызова.Вставить("РезультатОбработкиШтрихкода");
			ПараметрыСерверногоВызова.Вставить("КэшированныеЗначения");
			ПараметрыСерверногоВызова.Вставить("ПараметрыСканирования");
			ПараметрыСерверногоВызова.Вставить("Действие");
			ПараметрыСерверногоВызова.Вставить("ДанныеШтрихкода");
			ЗаполнитьЗначенияСвойств(ПараметрыСерверногоВызова, ДополнительныеПараметры);
			ДополнительныеПараметры = ПараметрыСерверногоВызова;
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая часть обработки события при изменении в формах списков.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма в которой возникло событие ПриИзменении.
//   Элемент - ТаблицаФормы - Элемент формы связанный со списком в котором возникло событие ПриИзменении.
Процедура СписокПриИзменении(Форма, Элемент) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.МаркировкаТоваровГИСМ.Форма.ФормаСписка"
			Или Форма.ИмяФормы = "Документ.ПеремаркировкаТоваровГИСМ.Форма.ФормаСписка" Тогда
				ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд
// Обработчик переопределяемой команды формы.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма объекта справочника или документа,
//  Команда - КомандаФормы     - команда формы.
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда) Экспорт
	
	//++ НЕ ГОСИС
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(Форма, Команда);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Выполняет процедуру разбиения строки табличной части. Установить СтандартнаяОбработка = Ложь при реализации.
// 
// Параметры:
//  СтандартнаяОбработка - Булево - признак библиотечной обработки события
//  ТабличнаяЧасть - ТабличнаяЧасть - Табличная часть объекта где происходит разбиение
//  ЭлементФормы   - ТаблицаФормы   - Элемент табличной части в пользовательском интерфейсе.
//  ПараметрыРазбиенияСтроки - См. ПараметрыРазбиенияСтроки
//  ОповещениеПослеРазбиения - ОписаниеОповещения - действия после разбиения (ожидаемый результат действия - новая строка)
Процедура РазбитьСтрокуТабличнойЧасти(СтандартнаяОбработка, ТабличнаяЧасть, ЭлементФормы, ПараметрыРазбиенияСтроки, ОповещениеПослеРазбиения) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСУТКлиент.РазбитьСтрокуТабличнойЧасти(
		ТабличнаяЧасть, ЭлементФормы, ОповещениеПослеРазбиения, ПараметрыРазбиенияСтроки);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемоеОборудование

// Вызывается перед обработкой штрихкодов, не привязанных ни к одной номенклатуре.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - процедура, которую нужно вызвать после выполнения обработки,
//  Форма - ФормаКлиентскогоПриложения - форма, в которой отсканировали штрихкоды,
//  ИмяСобытия - Строка - имя события, инициировавшее оповещение,
//  Параметр - Структура - данные для обработки,
//  Источник - Произвольный - источник события.
Процедура ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(ОписаниеОповещения, Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	//++ НЕ ГОСИС
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = Форма.УникальныйИдентификатор Тогда
		
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеШтрихкодов);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// В процедуре нужно реализовать алгоритм преобразования данных из подсистемы подключаемого оборудования.
//
// Параметры:
//  Результат - Массив - Массив структур со свойствами Штрихкод, Количество.
//  Параметр  - Массив - входящие данные.
Процедура ПреобразоватьДанныеСоСканераВМассив(Результат, Параметр) Экспорт
	
	//++ НЕ ГОСИС
	Результат = МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриПолученииДанныхИзТСД(ОписаниеОповещения, Форма, РезультатВыполнения) Экспорт
	
	//++ НЕ ГОСИС
	Если РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения.ТаблицаТоваров);
		
	Иначе
		
		СобытияФормИСКлиент.СообщитьОбОшибке(РезультатВыполнения);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

// Вызывает процедуру обработки подбора, если произошло оповещение из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ИмяСобытия - Строка - имя события, о котором происходит оповещение,
//  Параметр - Произвольный - переданный в сообщение параметр,
//  Источник - ФормаКлиентскогоПриложения - форма, в которой произошло оповещение.
Процедура ОбработкаОповещенияПодборНоменклатуры(ОповещениеПриЗавершении, ИмяСобытия, Параметр, Источник) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки подбора, если произошел выбор из формы подбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - ФормаКлиентскогоПриложения - форма, где осуществлен выбор.
Процедура ОбработкаВыбораПодборНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора контрагента, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения подбора номенклатуры,
//  ВыбранноеЗначение - Произвольный - результат выбора в подчиненной форме,
//  ИсточникВыбора - ФормаКлиентскогоПриложения - форма, где осуществлен выбор.
Процедура ОбработкаВыбораКонтрагента(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Контрагенты")
		Или СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Партнеры") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Выполняется при обработке выбора. Требуется выделить и обработать событие выбора серии.
// 
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - Форма для которой требуется обработать событие выбора.
//  ВыбранноеЗначение      - ОпределяемыйТип.СерияНоменклатуры - результат выбора.
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - Форма, в которой произведен выбор.
//  ПараметрыУказанияСерий - Произвольный - параметры указания серий формы.
Процедура ОбработкаВыбораСерии(Форма, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		Если Форма.ИмяФормы = "ОбщаяФорма.УточнениеСоставаУпаковкиИС" Тогда
			ВременныеПараметры = Новый Структура("ИмяТЧТовары,ИмяТЧСерии,ИмяИсточникаЗначенийВФормеОбъекта");
			ЗаполнитьЗначенияСвойств(ВременныеПараметры, ПараметрыУказанияСерий);
		
			ПараметрыУказанияСерий.ИмяТЧТовары = "ДанныеДляУточнения";
			ПараметрыУказанияСерий.ИмяТЧСерии = ПараметрыУказанияСерий.ИмяТЧТовары;
			ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "ЭтаФорма";
			НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбранноеЗначение);
			ЗаполнитьЗначенияСвойств(ПараметрыУказанияСерий, ВременныеПараметры);
		Иначе 
			НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

#Область Номенклатура

// Выполняется при начале выбора номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  ВидыПродукции        - ПеречислениеСсылка.ВидыПродукцииИС, Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Виды продукции.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораНоменклатуры(Владелец, ВидыПродукции, СтандартнаяОбработка, ОписаниеОповещения=Неопределено, Знач Реквизиты = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	Если НЕ(Реквизиты = Неопределено) Тогда
		ДополнительныеПараметры = Реквизиты;
	Иначе
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ОсобенностиУчета = Новый Массив;
	
	Если ТипЗнч(ВидыПродукции) = Тип("Массив") Тогда
		Для Каждого ВидПродукцииИС Из ВидыПродукции Цикл
			ОсобенностьУчета = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидПродукцииИС);
			Если ЗначениеЗаполнено(ОсобенностьУчета) Тогда
				ОсобенностиУчета.Добавить(ОсобенностьУчета);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОсобенностьУчета = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидыПродукции);
		Если ЗначениеЗаполнено(ОсобенностьУчета) Тогда
			ОсобенностиУчета.Добавить(ОсобенностьУчета);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	
	Если ОсобенностиУчета.Количество() > 0 Тогда
		ПараметрыОтбора.Вставить("ОсобенностьУчета", ОсобенностиУчета);
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ВидАлкогольнойПродукцииЕГАИС")
		И ЗначениеЗаполнено(Реквизиты.ВидАлкогольнойПродукцииЕГАИС) Тогда
		ПараметрыОтбора.Вставить("ВидАлкогольнойПродукции", ДополнительныеПараметры.ВидАлкогольнойПродукцииЕГАИС);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов",    ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("Отбор",                   ПараметрыОтбора);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	Если ДополнительныеПараметры.Свойство("ВидАлкогольнойПродукцииМаркируемый") Тогда
		ПараметрыФормы.Вставить("ВидАлкогольнойПродукцииМаркируемый", ДополнительныеПараметры.ВидАлкогольнойПродукцииМаркируемый);
	КонецЕсли;
	
	Если Реквизиты <> Неопределено
		И Реквизиты.Свойство("Номенклатура") Тогда
		Номенклатура = Реквизиты.Номенклатура;
	Иначе
		Номенклатура = ИнтеграцияИСУТКлиент.ЗначениеЭлементаФормыПоИмени(Владелец, "Номенклатура");
	КонецЕсли;
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", Номенклатура);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Владелец,,,, ОписаниеОповещения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняется при начале выбора упаковки номенклатуры. Требуется определить и открыть форму выбора.
//
// Параметры:
//  Владелец             - ФормаКлиентскогоПриложения  - Форма владелец (возможен владелец - элемент формы).
//  Номенклатура         - ОпределяемыйТип.Номенклатура - Номенклатура для отбора.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ОписаниеОповещения   - ОписаниеОповещения - Вызывается при выборе значения в форме выбора.
//  Реквизиты            - Структура - параметры формы создания номенклатуры.
//
Процедура ПриНачалеВыбораУпаковки(Владелец, Номенклатура, СтандартнаяОбработка, ОписаниеОповещения=Неопределено, Знач Реквизиты = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыФормы.Отбор.Вставить("ТипИзмеряемойВеличины", ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Упаковка"));
	ПараметрыФормы.Отбор.Вставить("Номенклатура", Номенклатура);
	
	ОткрытьФорму(
		"Справочник.УпаковкиЕдиницыИзмерения.ФормаВыбора",
		ПараметрыФормы, Владелец,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Выполняется при выборе действия открытия формы для выбора элемента ссылочного типа в поле составного типа.
// Можно переопределить Параметры, например, ИмяФормы.
// Можно отключить стандартную обработку и определить свой обработчик выбора (не рекомендуется).
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения  - Форма из которой вызывается событие.
//  Элемент              - ПолеФормы - Поле формы для которого выполняется действие.
//  Параметры            - Структура - структура параметров из:
//   Вид      - Строка - вид метаданных, например, Справочник
//   Имя      - Строка - имя объекта метаданных, например, Организации
//   ИмяФормы - Строка - имя формы для выбора, например, ФормаВыбора.
//  СтандартнаяОбработка - Булево - Использовать стандартную обработку события.
//  ПараметрыОткрытияФормы - Структура - Параметры, которые будут переданы в открываемую форму.
//  ОписаниеОповещения     - ОписаниеОповещения - Описание оповещения о закрытии открываемой формы.
//
Процедура ПолеСоставногоТипаОткрытьФормуВыбора(Форма, Элемент, Параметры, СтандартнаяОбработка, ПараметрыОткрытияФормы, ОписаниеОповещения) Экспорт
	
	//++ НЕ ГОСИС
	
	Если Параметры.Вид = "Справочник" И Параметры.Имя = "Склады" Тогда
		ВыборГруппыСкладов = Новый СписокЗначений;
		ВыборГруппыСкладов.Добавить(ПредопределенноеЗначение("Перечисление.ВыборГруппыСкладов.Запретить"));
		ПараметрыОткрытияФормы.Вставить("ВыборГруппыСкладов", ВыборГруппыСкладов);
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти